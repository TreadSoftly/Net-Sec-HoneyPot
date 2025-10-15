# SEC-UB1 Data Collection Checklist

After the Ubuntu security node is configured, gather the following outputs to verify health and to populate documentation.

## Wazuh Stack

```bash
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard
sudo /var/ossec/bin/list_agents -a
```

## rsyslog & NetFlow

```bash
sudo systemctl status rsyslog
sudo tail -n 50 /var/log/pfsense.log
nfdump -R /var/log/netflow -s srcip/bytes -a -o extended -t now-5m
```

## Docker (if using containerized Wazuh)

```bash
sudo docker ps
sudo docker compose -f /opt/wazuh-docker/single-node/docker-compose.yml ps
```

## Evidence Tasks

- Capture Wazuh dashboard screenshots (Agents, Discover view filtered for Cowrie/Sysmon).
- Export sanitized NetFlow reports for `docs/evidence/`.
- Document any manual configuration tweaks directly under `infra/ubuntu-sec-ub1/`.
