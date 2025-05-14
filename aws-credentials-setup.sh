#!/bin/bash

# Create AWS credentials directory if it doesn't exist
mkdir -p ~/.aws

# Create or update credentials file
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id=YOUR_ACCESS_KEY_ID
aws_secret_access_key=YOUR_SECRET_ACCESS_KEY
EOF

# Set proper permissions
chmod 600 ~/.aws/credentials

echo "AWS credentials file created. Please edit it with your actual credentials."
