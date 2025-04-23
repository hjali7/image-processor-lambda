#!/bin/bash
set -e

echo "🔗 [3/3] Configuring S3 trigger for Lambda..."

BUCKET_NAME="image-uploads"
FUNCTION_ARN="arn:aws:lambda:us-east-1:000000000000:function:image-processor"

awslocal lambda add-permission \
  --function-name image-processor \
  --statement-id s3invoke \
  --action "lambda:InvokeFunction" \
  --principal s3.amazonaws.com \
  --source-arn arn:aws:s3:::${BUCKET_NAME}

awslocal s3api put-bucket-notification-configuration \
  --bucket $BUCKET_NAME \
  --notification-configuration '{
    "LambdaFunctionConfigurations": [{
      "LambdaFunctionArn": "'"$FUNCTION_ARN"'",
      "Events": ["s3:ObjectCreated:*"]
    }]
  }'

echo "✅ S3 trigger configured for bucket '$BUCKET_NAME'"
