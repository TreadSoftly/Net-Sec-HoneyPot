#!/bin/bash

set -euo pipefail

# Enable core AWS security services for the honeypot account.
# Requires AWS CLI configured with appropriate permissions.

command -v aws >/dev/null 2>&1 || {
  echo "aws CLI not found in PATH. Install and configure credentials first." >&2
  exit 1
}

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
REGION="${AWS_REGION:-us-east-1}"
TRAIL_NAME="${TRAIL_NAME:-net-sec-honeypot-trail}"
TRAIL_BUCKET_BASE="${TRAIL_BUCKET_BASE:-net-sec-honeypot-log}"

BUCKET_NAME="$(printf "%s-%s-%s" "${TRAIL_BUCKET_BASE}" "${ACCOUNT_ID}" "${REGION}" | tr '[:upper:]' '[:lower:]')"
STANDARD_ARN="arn:aws:securityhub:${REGION}::standards/aws-foundational-security-best-practices/v/1.0.0"

echo "Using account ${ACCOUNT_ID} in region ${REGION}."
echo "CloudTrail bucket will be ${BUCKET_NAME}."

echo "Ensuring S3 bucket ${BUCKET_NAME} exists..."
if ! aws s3api head-bucket --bucket "${BUCKET_NAME}" >/dev/null 2>&1; then
  if [ "${REGION}" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "${BUCKET_NAME}" >/dev/null
  else
    aws s3api create-bucket \
      --bucket "${BUCKET_NAME}" \
      --create-bucket-configuration LocationConstraint="${REGION}" >/dev/null
  fi
  aws s3api put-bucket-versioning \
    --bucket "${BUCKET_NAME}" \
    --versioning-configuration Status=Enabled >/dev/null
  aws s3api put-bucket-encryption \
    --bucket "${BUCKET_NAME}" \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}' >/dev/null
fi

echo "Attaching CloudTrail bucket policy..."
POLICY_FILE="$(mktemp)"
cat >"${POLICY_FILE}" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${BUCKET_NAME}/AWSLogs/${ACCOUNT_ID}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${BUCKET_NAME}"
    }
  ]
}
EOF
aws s3api put-bucket-policy --bucket "${BUCKET_NAME}" --policy file://"${POLICY_FILE}" >/dev/null
rm -f "${POLICY_FILE}"

echo "Enabling AWS Security Hub in ${REGION}..."
aws securityhub enable-security-hub --region "${REGION}" >/dev/null 2>&1 || echo "Security Hub already enabled."

echo "Subscribing to AWS Foundational Security Best Practices..."
aws securityhub batch-enable-standards \
  --region "${REGION}" \
  --standards-subscription-requests StandardsArn="${STANDARD_ARN}" >/dev/null 2>&1 || echo "Standard subscription already active."

echo "Enabling GuardDuty..."
DETECTOR_ID="$(aws guardduty list-detectors --region "${REGION}" --query 'DetectorIds[0]' --output text)"
if [ "${DETECTOR_ID}" = "None" ]; then
  DETECTOR_ID="$(aws guardduty create-detector --enable --region "${REGION}" --query 'DetectorId' --output text)"
else
  aws guardduty update-detector --detector-id "${DETECTOR_ID}" --enable --region "${REGION}" >/dev/null
fi
echo "GuardDuty detector ID: ${DETECTOR_ID}"

echo "Ensuring CloudTrail trail ${TRAIL_NAME} exists..."
TRAIL_EXISTS="$(aws cloudtrail describe-trails --region "${REGION}" --query "trailList[?Name=='${TRAIL_NAME}']" --output text)"
if [ -z "${TRAIL_EXISTS}" ]; then
  aws cloudtrail create-trail \
    --name "${TRAIL_NAME}" \
    --s3-bucket-name "${BUCKET_NAME}" \
    --is-multi-region-trail \
    --enable-log-file-validation \
    --region "${REGION}" >/dev/null
fi
aws cloudtrail start-logging --name "${TRAIL_NAME}" --region "${REGION}"

echo "AWS security services enabled and configured."
