# rsyslog Ingestion

## Objective

Collect pfSense syslog events on `SEC-UB1` and forward into Wazuh.

## Configuration Steps

1. Install packages:

   ```bash
   sudo apt update
   sudo apt install -y rsyslog
   ```

2. Create config `/etc/rsyslog.d/10-pfsense.conf`:

   ```conf
   module(load="imudp")
   input(type="imudp" port="514" ruleset="pfsense")

   ruleset(name="pfsense") {
     action(type="omfile" file="/var/log/pfsense.log")
     action(type="ompipe" Pipe="/var/ossec/queue/ossec/queue")
   }
   ```

3. Ensure `wazuh-manager` user can read `/var/log/pfsense.log` (adjust permissions).
4. Restart services:

   ```bash
   sudo systemctl restart rsyslog
   sudo systemctl restart wazuh-manager
   ```

## Verification

- Run `sudo tail -f /var/log/pfsense.log` while generating pfSense traffic.
- Confirm Wazuh receives events tagged `firewall` / `dmz`.

## Hardening

- Restrict UDP/514 on host firewall to pfSense IP.
- Rotate logs with `/etc/logrotate.d/pfsense`.
