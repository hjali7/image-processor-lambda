#!/bin/bash
set -e

echo "📦 [2/3] Deploying Lambda function..."

FUNCTION_NAME="image-processor"
ROLE_ARN="arn:aws:iam::000000000000:role/lambda-role"
ZIP_PATH="/tmp/${FUNCTION_NAME}.zip"
SOURCE_PATH="/lambdas/image_processor/lambda_function.py"

rm -f $ZIP_PATH

zip -j $ZIP_PATH $SOURCE_PATH

awslocal lambda create-function \
  --function-name $FUNCTION_NAME \
  --runtime python3.9 \
  --handler lambda_function.lambda_handler \
  --role $ROLE_ARN \
  --zip-file fileb://$ZIP_PATH

echo "✅ Lambda '$FUNCTION_NAME' deployed."