# Wazuh Stack (Docker Compose)

## Prerequisites

- Ubuntu 22.04 LTS with 4 vCPU / 8 GB RAM minimum.
- Docker Engine + Docker Compose Plugin.
- Hostname: `sec-ub1.lab.local`.

## Installation Steps

1. Install dependencies:

   ```bash
   sudo apt update
   sudo apt install -y curl apt-transport-https ca-certificates gnupg
   ```
2. Install Docker Engine (follow <https://docs.docker.com/engine/install/ubuntu/>).
3. Clone Wazuh Docker deployment:

   ```bash
   git clone https://github.com/wazuh/wazuh-docker.git
   cd wazuh-docker/single-node
   ```
4. Adjust `.env`:
   - `WAZUH_VERSION=4.7.0` (or latest stable).
   - `ELASTICSEARCH_HEAP=4096m`.
   - `KIBANA_PORT=5601`.
5. Launch stack:

   ```bash
   sudo docker compose up -d
   ```
6. Wait for containers (`wazuh.manager`, `wazuh.indexer`, `wazuh.dashboard`) to become healthy.
7. Access dashboard at `https://sec-ub1.lab.local:5601` (default creds `admin` / `SecretPassword`).

## Post-Install

- Configure TLS agent enrollments using default `default.pem` or custom certificates.
- Enable index lifecycle management for improved retention.
- Set up email alerts or webhooks for high-severity events.
