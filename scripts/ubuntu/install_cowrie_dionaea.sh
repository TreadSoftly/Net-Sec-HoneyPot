#!/bin/bash

set -euo pipefail

# Install Cowrie and Dionaea honeypots on Ubuntu DMZ host.

if [[ $EUID -ne 0 ]]; then
  echo "Run as root."
  exit 1
fi

apt update
apt install -y git python3-virtualenv authbind dionaea

useradd -m -s /bin/bash cowrie || true

sudo -u cowrie bash <<'EOF'
set -e
cd "$HOME"
if [ ! -d cowrie ]; then
  git clone https://github.com/cowrie/cowrie.git
fi
cd cowrie
python3 -m venv cowrie-env
source cowrie-env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
cp -n etc/cowrie.cfg.dist etc/cowrie.cfg
EOF

cat <<'EOF' >/etc/systemd/system/cowrie.service
[Unit]
Description=Cowrie Honeypot
After=network.target

[Service]
User=cowrie
Group=cowrie
WorkingDirectory=/home/cowrie/cowrie
ExecStart=/home/cowrie/cowrie/cowrie-env/bin/python /home/cowrie/cowrie/src/cowrie/start.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now cowrie
systemctl enable --now dionaea

echo "Cowrie and Dionaea installed. Configure pfSense NAT before exposing to WAN."

