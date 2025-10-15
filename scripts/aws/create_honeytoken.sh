#!/bin/bash

set -euo pipefail

# Create a no-permission IAM user and access key to serve as a honeytoken.

command -v aws >/dev/null 2>&1 || {
  echo "aws CLI not found in PATH. Install and configure credentials first." >&2
  exit 1
}

command -v jq >/dev/null 2>&1 || {
  echo "jq not found in PATH. Install jq to parse IAM output (https://stedolan.github.io/jq/)." >&2
  exit 1
}

if [ -z "${HONEYTOKEN_USER:-}" ]; then
  echo "Set HONEYTOKEN_USER to the desired IAM username (e.g., export HONEYTOKEN_USER=honeypot-token)."
  exit 1
fi

OUTPUT_DIR="${OUTPUT_DIR:-.}"
mkdir -p "${OUTPUT_DIR}"

echo "Creating IAM user ${HONEYTOKEN_USER}..."
aws iam create-user --user-name "${HONEYTOKEN_USER}" >/dev/null

TMP_POLICY="$(mktemp)"
cleanup() {
  rm -f "${TMP_POLICY}"
}
trap cleanup EXIT

echo "Attaching deny-all policy to ensure no permissions..."
cat > "${TMP_POLICY}" <<'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF
aws iam put-user-policy \
  --user-name "${HONEYTOKEN_USER}" \
  --policy-name "HoneytokenDenyAll" \
  --policy-document file://"${TMP_POLICY}" >/dev/null

echo "Creating access key..."
ACCESS_KEY_JSON="$(aws iam create-access-key --user-name "${HONEYTOKEN_USER}")"
SECRET_FILE="${OUTPUT_DIR}/honeytoken-${HONEYTOKEN_USER}.json"
echo "${ACCESS_KEY_JSON}" > "${SECRET_FILE}"
chmod 600 "${SECRET_FILE}"

ACCESS_KEY_ID="$(echo "${ACCESS_KEY_JSON}" | jq -r '.AccessKey.AccessKeyId')"

echo "Tagging user for detections..."
aws iam tag-user \
  --user-name "${HONEYTOKEN_USER}" \
  --tags Key=Purpose,Value=Honeytoken Key=Detection,Value=EventBridge >/dev/null

aws iam tag-user \
  --user-name "${HONEYTOKEN_USER}" \
  --tags Key=Purpose,Value=Honeytoken Key=Detection,Value=EventBridge >/dev/null

echo "Honeytoken created. Store ${SECRET_FILE} securely and add key ID ${ACCESS_KEY_ID} to EventBridge filters."
