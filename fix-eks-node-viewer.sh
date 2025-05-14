#!/bin/bash

# Update AWS config to remove credential_source
mkdir -p ~/.aws
cat > ~/.aws/config << EOF
[default]
region = us-east-1
EOF

# Try running eks-node-viewer with explicit AWS environment variables
export AWS_SDK_LOAD_CONFIG=1
export AWS_REGION=us-east-1

echo "Modified AWS config and set environment variables. Now try running eks-node-viewer again."
