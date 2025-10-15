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
chmod +x scripts/aws/enable_services.sh
AWS_REGION=us-east-1 ./scripts/aws/enable_services.sh
```

### Validate Results

```bash
aws securityhub describe-hub --region us-east-1
aws guardduty list-detectors --region us-east-1
aws cloudtrail describe-trails --region us-east-1
aws s3api list-buckets --query "Buckets[?starts_with(Name, 'net-sec-honeypot-log')].Name"
```

## Honeytoken Workflow

```bash
export HONEYTOKEN_USER=honeypot-token
export OUTPUT_DIR=/home/cloudshell-user
./scripts/aws/create_honeytoken.sh

export HONEYTOKEN_ACCESS_KEY_ID=$(jq -r '.AccessKey.AccessKeyId' /home/cloudshell-user/honeytoken-${HONEYTOKEN_USER}.json)
export ALERT_EMAIL="you@example.com"
./scripts/aws/eventbridge_sns.sh
```

Confirm SNS subscription via email, then force a test call (e.g., `aws sts get-caller-identity --access-key ...`) to generate an alert.

## Data to Collect for Documentation

After each run, capture sanitized command output (e.g., `securityhub-status.txt`) and store under `docs/evidence/` for future screenshots.
