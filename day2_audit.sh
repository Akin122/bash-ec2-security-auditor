#!/bin/bash
echo "=== AWS Day 2 Security Audit ==="
echo "Account: $(aws sts get-caller-identity --query Account --output text)"
echo "User: $(aws sts get-caller-identity --query Arn --output text)"
echo ""

echo "--- 1. Checking IAM Users ---"
aws iam list-users --query 'Users[].UserName' --output table

echo "--- 2. Checking for Root Access Keys ---"
aws iam get-account-summary --query 'SummaryMap.AccountAccessKeysPresent' --output text

echo "--- 3. Checking S3 Buckets ---"
aws s3 ls

echo "--- 4. Checking Security Groups for 0.0.0.0/0 ---"
aws ec2 describe-security-groups --query 'SecurityGroups[].{Name:GroupName,ID:GroupId,OpenPorts:IpPermissions[?IpRanges[?CidrIp==`0.0.0.0/0`]]}' --output table

echo "--- 5. Checking for MFA on Users ---"
aws iam list-users --query 'Users[].[UserName]' --output text | while read user; do
  echo "User: $user"
  aws iam list-mfa-devices --user-name $user --output text
done

echo "=== Audit Complete ==="
