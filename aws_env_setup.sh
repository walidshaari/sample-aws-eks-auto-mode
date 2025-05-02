#!/bin/bash

# AWS Environment Variables Setup Script
# This script sets up common AWS environment variables

# AWS Region
export AWS_REGION="us-east-1"  # Change this to your preferred region
export AWS_DEFAULT_REGION="$AWS_REGION"

# EKS Cluster Configuration
export EKS_CLUSTER_NAME="my-eks-cluster"  # Change this to your cluster name

# Optional: Other common AWS environment variables
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export AWS_OUTPUT="json"  # Set your preferred output format (json, text, table)

# S3 Configuration
export S3_BUCKET_NAME="my-application-bucket"  # Change this to your bucket name

# ECR Configuration
export ECR_REPOSITORY="my-app-repo"  # Change this to your ECR repository name

# CloudFormation Configuration
export CFN_STACK_NAME="my-application-stack"  # Change this to your stack name

# Print the configured environment variables
echo "AWS Environment Variables configured:"
echo "AWS_REGION: $AWS_REGION"
echo "EKS_CLUSTER_NAME: $EKS_CLUSTER_NAME"
echo "AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"
echo "S3_BUCKET_NAME: $S3_BUCKET_NAME"
echo "ECR_REPOSITORY: $ECR_REPOSITORY"
echo "CFN_STACK_NAME: $CFN_STACK_NAME"

# Instructions for usage
echo ""
echo "To use these environment variables in your current shell session, run:"
echo "source $(pwd)/aws_env_setup.sh"
