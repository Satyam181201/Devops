#!/bin/bash

###############################################

#Author : Satyam

#Date : 31st-Oct-2026

#Version : v1

#This script will report aws resource usage

##############################################

set -x

# AWS S3
# AWS EC2
# AWS LAMBDA
# AWS IAM USER


# list aws s3
echo "Print list of s3 buckets : "
aws s3 ls


# list EC2 Instances
echo "Print list of ec2 instnaces : "
aws ec2 describe-instances
#or#

aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'           #jq is use to parse json and yq xml parser


# list LAMBDA
echo "Print list of lambda : "
aws lambda list-functions


# list IAM users
echo "Print list of iam users : "
aws iam list-users