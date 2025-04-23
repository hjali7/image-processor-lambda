#!/bin/bash
set -e

echo "🔐 Setting executable permission for setup scripts..."
chmod +x /scripts/*.sh

echo "🚀 Running setup steps..."
/scripts/01-create-buckets.sh
/scripts/02-deploy-lambda.sh
/scripts/03-configure-triggers.sh

echo "🎉 All setup scripts executed successfully."
