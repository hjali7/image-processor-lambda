#!/bin/bash
set -e

echo "🔧 [1/3] Creating S3 buckets..."

# awscli-local
if ! command -v awslocal &> /dev/null; then
  echo "❌ awslocal not found. Please install it using: pip install awscli-local"
  exit 1
fi

# buckets names
UPLOAD_BUCKET="image-uploads"
PROCESSED_BUCKET="image-processed"

# create buckets
awslocal s3 mb s3://$UPLOAD_BUCKET
awslocal s3 mb s3://$PROCESSED_BUCKET

echo "✅ Buckets created: $UPLOAD_BUCKET, $PROCESSED_BUCKET"
