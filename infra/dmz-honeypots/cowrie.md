# Cowrie Honeypot

## Overview

Cowrie emulates SSH and Telnet services to capture brute force attempts and command execution.

## Installation (Ubuntu 22.04)

```bash
sudo apt update
sudo apt install -y git python3-virtualenv authbind
sudo useradd -m cowrie
sudo su - cowrie
git clone https://github.com/cowrie/cowrie.git
cd cowrie
virtualenv --python=python3 cowrie-env
source cowrie-env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
cp etc/cowrie.cfg.dist etc/cowrie.cfg
```

## Configuration

- Set `hostname = sshd` to mimic real systems.
- Bind SSH to port 2222 (`listen_endpoints = tcp:2222:interface=0.0.0.0`).
- Enable JSON logging for Wazuh ingestion (`output_jsonlog:enabled = true`).
- Configure authbind for low port exposure if remapping to 22.

## Service

Create systemd unit `/etc/systemd/system/cowrie.service` running under `cowrie` user. Enable auto-start:

```bash
sudo systemctl enable --now cowrie
```

## Integration

- Install Wazuh agent on HP-UB1 and forward Cowrie JSON logs.
- Ensure NAT on pfSense maps WAN 22 -> DMZ 2222.
- Create test session and confirm alert `100001`.
