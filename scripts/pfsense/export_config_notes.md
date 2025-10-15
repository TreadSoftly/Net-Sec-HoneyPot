# pfSense Config Export Notes

## Backup Procedure

1. Navigate to **Diagnostics > Backup & Restore**.
2. Under **Backup Configuration**, select:
   - `All` configuration areas.
   - Check `Encrypt configuration file` if storing outside lab.
3. Click **Download configuration** and save as `pfsense-config-YYYYMMDD.xml`.

## Automation Tips

- Use `scp` from SEC-UB1 to periodically pull backups:
  ```bash
  scp admin@10.10.0.1:/cf/conf/config.xml /opt/backups/pfsense-config.xml
  ```
- Store encrypted copies only; never commit raw XML into the repo.

## Restore Considerations

- When importing to a new instance, ensure interface assignments match VMnet layout.
- After restore, re-validate DHCP leases, NAT rules, and logging outputs.
