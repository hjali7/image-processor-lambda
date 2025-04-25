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

# ✅ صبر تا Lambda آماده بشه
echo "⏳ Waiting for Lambda to become Active..."
for i in {1..10}; do
  state=$(awslocal lambda get-function-configuration --function-name image-processor | jq -r .State)
  echo "   → Lambda state: $state"
  [ "$state" = "Active" ] && break
  sleep 3
done

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