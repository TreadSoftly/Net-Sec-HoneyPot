# Contributing to Net-Sec-HoneyPot

Thanks for helping improve this defensive lab! This repository is built to show
professional security engineering practices. Please follow the guidelines
below when contributing.

## Getting Started

1. Fork the repo or create a feature branch from `main`.
2. Run local linting or formatting tools relevant to your change (Markdownlint,
   Yamllint, shellcheck, etc.).
3. Keep secrets and sensitive data out of commits. Use placeholder values or the
   sanitization utilities provided.

## Commit Style

We use [Conventional Commits](https://www.conventionalcommits.org/) to keep
history easy to scan. Examples:

- `feat(detctions): add wazuh rule for cowrie brute force`
- `docs(runbook): expand dmz egress response steps`
- `chore(ci): bump gitleaks action`

## Pull Request Checklist

- PR title follows Conventional Commits.
- CI passes: Markdownlint and Yamllint (`.github/workflows`).
- No generated secrets, auth tokens, or unredacted IPs are included.
- Update docs/runbooks/detections when behavior changes.

## Reporting Issues

Open an issue using the templates under `.github/ISSUE_TEMPLATE/`.
Label it with the appropriate area (`area/infra`, `area/detections`, etc.) and
priority (`prio/high`, `prio/med`, `prio/low`).

## Questions

Use GitHub Discussions or open a `content_request` issue to propose new
scenarios, detections, or documentation improvements.
