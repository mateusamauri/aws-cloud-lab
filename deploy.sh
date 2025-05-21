#!/bin/bash

# AWS CLI Deploy Script for Static Website

# Variables
BUCKET_NAME="aws-cloud-lab-mateus"
REGION="us-east-1"

# Create S3 bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION \
  --create-bucket-configuration LocationConstraint=$REGION

# Enable website hosting
aws s3 website s3://$BUCKET_NAME/ \
  --index-document index.html

# Sync files from ./site folder to S3 bucket
aws s3 sync ./site s3://$BUCKET_NAME \
  --acl public-read

# Output URL
echo "Website URL: http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com"