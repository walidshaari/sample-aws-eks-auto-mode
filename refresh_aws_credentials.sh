#!/bin/bash

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)

# Get the role name
ROLE_NAME=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/iam/security-credentials/)

# Get the credentials
CREDS=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/iam/security-credentials/$ROLE_NAME)

# Extract the credentials
export AWS_ACCESS_KEY_ID=$(echo $CREDS | grep -o '"AccessKeyId" : "[^"]*' | cut -d'"' -f4)
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | grep -o '"SecretAccessKey" : "[^"]*' | cut -d'"' -f4)
export AWS_SESSION_TOKEN=$(echo $CREDS | grep -o '"Token" : "[^"]*' | cut -d'"' -f4)

echo "AWS credentials refreshed successfully!"
echo "Expiration: $(echo $CREDS | grep -o '"Expiration" : "[^"]*' | cut -d'"' -f4)"

# Verify the credentials
echo "Verifying credentials..."
aws sts get-caller-identity
