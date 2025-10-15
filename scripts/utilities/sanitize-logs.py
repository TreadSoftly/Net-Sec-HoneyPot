#!/usr/bin/env python3
"""
Redact sensitive tokens (IP addresses, emails, AWS keys) from log files or stdin.
Usage:
    python sanitize-logs.py input.log > sanitized.log
"""

import re
import sys
from typing import Iterable

IPV4_REGEX = re.compile(r"\b(?:\d{1,3}\.){3}\d{1,3}\b")
EMAIL_REGEX = re.compile(r"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}")
AWS_KEY_REGEX = re.compile(r"AKIA[0-9A-Z]{16}")


def sanitize_line(line: str) -> str:
    line = IPV4_REGEX.sub("REDACTED_IP", line)
    line = EMAIL_REGEX.sub("redacted@example.com", line)
    line = AWS_KEY_REGEX.sub("REDACTED_AWS_KEY", line)
    return line


def iterate_lines() -> Iterable[str]:
    if len(sys.argv) > 1:
        for path in sys.argv[1:]:
            with open(path, "r", encoding="utf-8") as handle:
                for raw in handle:
                    yield raw
    else:
        for raw in sys.stdin:
            yield raw


def main() -> None:
    for raw_line in iterate_lines():
        sys.stdout.write(sanitize_line(raw_line))


if __name__ == "__main__":
    main()

