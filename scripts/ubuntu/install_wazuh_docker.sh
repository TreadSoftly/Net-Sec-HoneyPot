#!/bin/bash

set -euo pipefail

# Install Docker and deploy Wazuh single-node stack on Ubuntu.

if [[ $EUID -ne 0 ]]; then
  echo "Run as root."
  exit 1
fi

apt update
apt install -y ca-certificates curl gnupg git

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

if [ ! -d /opt/wazuh-docker ]; then
  git clone https://github.com/wazuh/wazuh-docker.git /opt/wazuh-docker
fi

cd /opt/wazuh-docker/single-node
cp -n env.example .env || true

sed -i 's/^WAZUH_VERSION=.*/WAZUH_VERSION=4.7.0/' .env
sed -i 's/^ELASTICSEARCH_HEAP=.*/ELASTICSEARCH_HEAP=4096m/' .env

docker compose up -d

echo "Wazuh single-node stack deployed. Access dashboard on port 5601."

