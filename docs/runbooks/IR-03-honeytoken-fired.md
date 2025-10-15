# IR-03 AWS Honeytoken Fired

## Trigger

- SNS email or EventBridge alert indicating API activity using the honeytoken IAM access key.

## Triage (15 min)

1. Confirm alert metadata: API `eventName`, source IP, region, and user agent.
2. Validate that the key remains unprivileged and unused by legitimate automation.
3. Search CloudTrail for additional events tied to the access key to understand intent (enumeration vs. privilege escalation).
4. If the source IP is public cloud infrastructure, check if other lab systems saw traffic from the same address.

## Contain & Eradicate

- Immediately deactivate and delete the compromised honeytoken credentials.
- Rotate any lab credentials stored alongside the token (e.g., shared password vault entries).
- Review public repositories, tickets, or documentation to ensure the key was not accidentally exposed.

## Recover & Lessons

- Generate a new honeytoken with a fresh key ID and update alerting targets.
- Improve sanitization automation (`scripts/utilities/sanitize-logs.py`) if leakage was internal.
- Document the incident in `docs/evidence/` with sanitized screenshots and timeline.
