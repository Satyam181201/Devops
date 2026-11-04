#!/bin/bash

################################
# Author: Satyam
# Date: $(date)
#
# Version: v1
#
# This script will report the AWS resource usage
################################

# Disable debug mode for cron (comment out set -x)
# set -x

# Set output file with timestamp
OUTPUT_FILE="/home/$(whoami)/aws_resource_report_$(date +%Y%m%d_%H%M%S).txt"

# Redirect all output to file
exec > "$OUTPUT_FILE" 2>&1

echo "AWS Resource Tracker Report"
echo "Generated on: $(date)"
echo ""

# AWS S3
echo "=========================================="
echo "Print list of S3 buckets"
echo "=========================================="
aws s3 ls

echo ""
echo "=========================================="
echo "Print list of EC2 instances"
echo "=========================================="
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,Tags[?Key==`Name`].Value|[0]]' --output table

echo ""
echo "=========================================="
echo "Print list of Lambda functions"
echo "=========================================="
aws lambda list-functions --query 'Functions[*].[FunctionName,Runtime,LastModified]' --output table

echo ""
echo "=========================================="
echo "Print list of IAM users"
echo "=========================================="
aws iam list-users --query 'Users[*].[UserName,CreateDate]' --output table

echo ""
echo "=========================================="
echo "Print list of RDS instances"
echo "=========================================="
aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus,Engine]' --output table 2>/dev/null || echo "No RDS instances found"

echo ""
echo "=========================================="
echo "Print list of EBS volumes"
echo "=========================================="
aws ec2 describe-volumes --query 'Volumes[*].[VolumeId,Size,State,VolumeType]' --output table

echo ""
echo "=========================================="
echo "Print list of VPCs"
echo "=========================================="
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,State,CidrBlock,Tags[?Key==`Name`].Value|[0]]' --output table

echo ""
echo "=========================================="
echo "Report saved to: $OUTPUT_FILE"
echo "=========================================="
