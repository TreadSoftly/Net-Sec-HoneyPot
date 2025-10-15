#!/bin/bash

set -euo pipefail

# Create EventBridge rule and SNS topic to alert on honeytoken usage.

command -v aws >/dev/null 2>&1 || {
  echo "aws CLI not found in PATH. Install and configure credentials first." >&2
  exit 1
}

if [ -z "${HONEYTOKEN_ACCESS_KEY_ID:-}" ]; then
  echo "Set HONEYTOKEN_ACCESS_KEY_ID to the AccessKeyId of the honeytoken (e.g., export HONEYTOKEN_ACCESS_KEY_ID=AKIA...)."
  exit 1
fi

REGION="${AWS_REGION:-us-east-1}"
RULE_NAME="${RULE_NAME:-HoneytokenAccess}"
TOPIC_NAME="${TOPIC_NAME:-net-sec-honeypot-alerts}"
EVENT_BUS_NAME="${EVENT_BUS_NAME:-default}"

echo "Creating SNS topic ${TOPIC_NAME} in ${REGION}..."
TOPIC_ARN="$(aws sns create-topic --name "${TOPIC_NAME}" --region "${REGION}" --query 'TopicArn' --output text)"

if [ -n "${ALERT_EMAIL:-}" ]; then
  echo "Subscribing ${ALERT_EMAIL} to SNS topic..."
  aws sns subscribe --topic-arn "${TOPIC_ARN}" --protocol email --notification-endpoint "${ALERT_EMAIL}" --region "${REGION}" >/dev/null
fi

echo "Creating EventBridge rule ${RULE_NAME}..."
aws events put-rule \
  --name "${RULE_NAME}" \
  --event-bus-name "${EVENT_BUS_NAME}" \
  --event-pattern "{
    \"source\": [\"aws.signin\", \"aws.iam\", \"aws.s3\", \"aws.ec2\"],
    \"detail\": {
      \"userIdentity\": {
        \"accessKeyId\": [\"${HONEYTOKEN_ACCESS_KEY_ID}\"]
      }
    }
  }" \
  --state ENABLED \
  --region "${REGION}" >/dev/null

echo "Adding SNS target..."
aws events put-targets \
  --rule "${RULE_NAME}" \
  --event-bus-name "${EVENT_BUS_NAME}" \
  --targets "Id"="SnsTarget","Arn"="${TOPIC_ARN}" \
  --region "${REGION}" >/dev/null

echo "EventBridge to SNS pipeline ready. Confirm email subscription to start receiving alerts."
