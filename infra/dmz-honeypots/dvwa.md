# Damn Vulnerable Web Application (Optional)

## Deployment

1. Install dependencies on HP-UB1 or separate VM:

   ```bash
   sudo apt update
   sudo apt install -y docker.io docker-compose
   ```

2. Create compose file `/opt/dvwa/docker-compose.yml`:

   ```yaml
   version: "3"
   services:
     dvwa:
       image: vulnerables/web-dvwa
       restart: unless-stopped
       ports:
         - "80:80"
   ```

3. Start service:

   ```bash
   sudo docker compose -f /opt/dvwa/docker-compose.yml up -d
   ```

## Exposure

- Map pfSense WAN port 80 to DMZ host port 80 when DVWA is active.
- If Dionaea also uses port 80, coordinate scheduling or use alternate port.

## Hardening / Safety

- Keep DVWA isolated; do not reuse credentials from production systems.
- Reset DVWA database regularly with the built-in setup/reset button.
- Capture `ocs` events via Wazuh agent for login attempts and vulnerability exercises.

## Evidence

- Take screenshot of DVWA homepage via WAN IP for `docs/evidence/images/`.
- Document exploitation walkthroughs in future detection stories.
