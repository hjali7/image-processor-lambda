#!/bin/bash
set -e

echo "🔐 Setting executable permission for setup scripts..."
chmod +x /scripts/*.sh

echo "🚀 Running setup steps..."

# 1. ساخت باکت‌ها (اگر وجود ندارند)
echo "🔧 [1/3] Creating S3 buckets..."
for bucket in image-uploads image-processed; do
  if awslocal s3api head-bucket --bucket $bucket 2>/dev/null; then
    echo "ℹ️ Bucket '$bucket' already exists."
  else
    awslocal s3 mb s3://$bucket
    echo "✅ Created bucket: $bucket"
  fi
done

# 2. ساخت یا به‌روزرسانی Lambda
echo "📦 [2/3] Deploying Lambda function..."
cd /lambdas
zip -r function.zip . > /dev/null

if ! awslocal lambda get-function --function-name image-processor > /dev/null 2>&1; then
  awslocal lambda create-function \
    --function-name image-processor \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://function.zip
  echo "✅ Lambda 'image-processor' created."
else
  awslocal lambda update-function-code \
    --function-name image-processor \
    --zip-file fileb://function.zip > /dev/null
  echo "✅ Lambda 'image-processor' updated."
fi

# 3. اعطای پرمیشن (اجازه تریگر شدن توسط S3)
echo "🔗 [3/3] Configuring S3 trigger for Lambda..."

if awslocal lambda remove-permission --function-name image-processor --statement-id s3invoke 2>/dev/null; then
  echo "ℹ️ Removed old permission."
fi

awslocal lambda add-permission \
  --function-name image-processor \
  --statement-id s3invoke \
  --action "lambda:InvokeFunction" \
  --principal s3.amazonaws.com \
  --source-arn arn:aws:s3:::image-uploads

# 4. تنظیم Notification تریگر روی باکت
awslocal s3api put-bucket-notification-configuration \
  --bucket image-uploads \
  --notification-configuration '{
    "LambdaFunctionConfigurations": [
      {
        "LambdaFunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:image-processor",
        "Events": ["s3:ObjectCreated:*"]
      }
    ]
  }'

echo "🎉 Setup completed successfully."