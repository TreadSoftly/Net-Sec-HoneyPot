#!/bin/bash

set -euo pipefail

# Configure rsyslog to collect pfSense logs and forward to Wazuh queue.

if [[ $EUID -ne 0 ]]; then
  echo "Run as root."
  exit 1
fi

cat <<'EOF' >/etc/rsyslog.d/10-pfsense.conf
module(load="imudp")
input(type="imudp" port="514" ruleset="pfsense")

ruleset(name="pfsense") {
  action(type="omfile" file="/var/log/pfsense.log")
  action(type="ompipe" Pipe="/var/ossec/queue/ossec/queue")
}
EOF

touch /var/log/pfsense.log
chown ossec:ossec /var/log/pfsense.log

systemctl restart rsyslog
systemctl restart wazuh-manager

echo "rsyslog configured for pfSense ingestion."

