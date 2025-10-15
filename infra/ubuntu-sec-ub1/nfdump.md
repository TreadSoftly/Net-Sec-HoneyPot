# nfdump Flow Collector

## Install

```bash
sudo apt update
sudo apt install -y nfdump
sudo mkdir -p /var/log/netflow
```

## Service Configuration

Create systemd unit `/etc/systemd/system/nfcapd.service`:

```ini
[Unit]
Description=NetFlow Capture Daemon
After=network.target

[Service]
ExecStart=/usr/bin/nfcapd -D -l /var/log/netflow -p 2055 -n sec-ub1
Restart=always

[Install]
WantedBy=multi-user.target
```

Then enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now nfcapd
```

## pfSense Export

1. Navigate to **Status > System Logs > Settings > Netflow**.
2. Enable NetFlow, set **Collector** to `SEC-UB1` IP, port `2055`, and version `9`.
3. Apply changes and monitor `nfcapd` logs.

## Queries

- Top talkers (5 min window):

  ```bash
  nfdump -R /var/log/netflow -s srcip/bytes -a -o extended -t now-5m
  ```

- DMZ to LAN attempts:

  ```bash
  nfdump -R /var/log/netflow -o json 'src net 10.20.0.0/24 and dst net 10.10.0.0/24'
  ```

## Maintenance

- Rotate NetFlow files with cron: `find /var/log/netflow -type f -mtime +7 -delete`.
- Sync with `docs/evidence/` by exporting sanitized screenshots.
