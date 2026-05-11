echo ""
echo "=== CIS 1.5-1.11: IAM Password Policy Audit ==="
echo "Checking AWS account password policy..."

# Check if password policy exists
if ! aws iam get-account-password-policy &>/dev/null; then

echo ""
echo "=== CIS 1.5-1.11: IAM Password Policy Audit ==="
echo "Checking AWS account password policy..."

# Check if password policy exists
if ! aws iam get-account-password-policy &>/dev/null; then
    echo "❌ FAIL: CIS 1.5 - No IAM password policy set"
    echo "Risk: Users can set weak passwords"
else
    echo "✅ PASS: Password policy exists. Details:"
    aws iam get-account-password-policy --query 'PasswordPolicy.{
        Uppercase:RequireUppercaseCharacters,
        Lowercase:RequireLowercaseCharacters, 
        Numbers:RequireNumbers,
        Symbols:RequireSymbols,
        MinLength:MinimumPasswordLength,
        ReusePrevention:PasswordReusePrevention,
        MaxAge:MaxPasswordAge
    }' --output table
    
    # Check CIS requirements
    MIN_LENGTH=$(aws iam get-account-password-policy --query 'PasswordPolicy.MinimumPasswordLength' --output text)
    if [ "$MIN_LENGTH" -lt 14 ]; then
        echo "⚠️  WARNING: CIS 1.8 - Min password length is $MIN_LENGTH, should be >= 14"
    fi
fi
echo "=== Password Policy Check Complete ==="    echo "❌ FAIL: CIS 1.5 - No IAM password policy set"
    echo "Risk: Users can set weak passwords"
else
    echo "✅ PASS: Password policy exists. Details:"
    aws iam get-account-password-policy --query 'PasswordPolicy.{
        Uppercase:RequireUppercaseCharacters,
        Lowercase:RequireLowercaseCharacters, 
        Numbers:RequireNumbers,
        Symbols:RequireSymbols,
        MinLength:MinimumPasswordLength,
        ReusePrevention:PasswordReusePrevention,
        MaxAge:MaxPasswordAge
    }' --output table
    
    # Check CIS requirements
    MIN_LENGTH=$(aws iam get-account-password-policy --query 'PasswordPolicy.MinimumPasswordLength' --output text)
    if [ "$MIN_LENGTH" -lt 14 ]; then
        echo "⚠️  WARNING: CIS 1.8 - Min password length is $MIN_LENGTH, should be >= 14"
    fi
fi
echo "=== Password Policy Check Complete ==="#!/bin/bash
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

# === DAY 3: CIS 1.5-1.11 PASSWORD POLICY AUDIT ===
echo
echo "=== CIS 1.5-1.11: IAM Password Policy Audit ==="
echo "Checking AWS account password policy..."

# Check if password policy exists
if ! aws iam get-account-password-policy >/dev/null 2>&1; then
    echo "❌ FAIL: CIS 1.5 - No IAM password policy set"
    echo "Risk: Users can set weak passwords"
else
    echo "✅ PASS: Password policy exists. Details:"
    aws iam get-account-password-policy --query 'PasswordPolicy.{Uppercase:RequireUppercaseCharacters,Lowercase:RequireLowercaseCharacters,Numbers:RequireNumbers,Symbols:RequireSymbols,MinLength:MinimumPasswordLength,ReusePrevention:PasswordReusePrevention,MaxAge:MaxPasswordAge}' --output table
    
    # Check CIS requirements
    MIN_LENGTH=$(aws iam get-account-password-policy --query 'PasswordPolicy.MinimumPasswordLength' --output text)
    if [ "$MIN_LENGTH" -lt 14 ]; then
        echo "⚠️  WARNING: CIS 1.8 - Min password length is $MIN_LENGTH, should be >= 14"
    fi
fi
echo "=== Password Policy Check Complete ==="
