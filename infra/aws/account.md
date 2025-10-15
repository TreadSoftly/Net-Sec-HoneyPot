# AWS Account Checklist

- **Account ID:** `211125358149`
- **Primary Region:** `us-east-1`
- **Owner:** Ray Draleaus
- **Execution Environment:** AWS CloudShell (`cloudshell-user`)

## Verify Identity & Region

```bash
aws sts get-caller-identity
aws configure get region
```

## Baseline Security Services

Run after cloning the repo in CloudShell:

```bash
AWS_REGION=us-east-1 ./scripts/aws/enable_services.sh
```

### Validate Results

```bash
aws securityhub describe-hub --region us-east-1
aws guardduty list-detectors --region us-east-1
aws cloudtrail describe-trails --region us-east-1
aws s3api list-buckets --query "Buckets[?starts_with(Name, 'net-sec-honeypot-log')].Name"
```

### Current State (2025-10-15)

- Security Hub HubArn: `arn:aws:securityhub:us-east-1:211125358149:hub/default`
- GuardDuty detector: `80ccf31e152e65de4379aa6c201d173c`
- CloudTrail trail: `net-sec-honeypot-trail`
  - S3 bucket: `net-sec-honeypot-log-211125358149-us-east-1`
  - Log file validation: enabled

## Honeytoken Workflow

```bash
export HONEYTOKEN_USER=honeypot-token
export OUTPUT_DIR=/home/cloudshell-user
./scripts/aws/create_honeytoken.sh

export HONEYTOKEN_ACCESS_KEY_ID=$(jq -r '.AccessKey.AccessKeyId' /home/cloudshell-user/honeytoken-${HONEYTOKEN_USER}.json)
export ALERT_EMAIL="shadowburner@protonmail.com"
./scripts/aws/eventbridge_sns.sh
```

### Honeytoken Details (2025-10-15)

- `AccessKeyId`: `AKIATCKANJZC3K2P4HHI`
- SNS topic ARN: `arn:aws:sns:us-east-1:211125358149:net-sec-honeypot-alerts`
- Subscription ARN (email): `arn:aws:sns:us-east-1:211125358149:net-sec-honeypot-alerts:954f86bf-c755-4c79-94dc-d8e27a9012c7`
- Test command:

  ```bash
  AWS_ACCESS_KEY_ID=$HONEYTOKEN_ACCESS_KEY_ID \
  AWS_SECRET_ACCESS_KEY=dummy \
  AWS_SESSION_TOKEN=dummy \
  aws sts get-caller-identity --region us-east-1 || true
  ```

  SNS should deliver a `SignatureDoesNotMatch` alert email. Save sanitized copies under `docs/evidence/`.

> Rotate the honeytoken (delete + re-run the scripts) if the secret ever leaks outside this lab.

## Data to Collect for Documentation

After each run, capture sanitized command output (e.g., `securityhub-status.txt`) and store under `docs/evidence/` for future screenshots.
