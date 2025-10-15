# Splunk Saved Searches

## Windows Brute Force

File: `detections/splunk/searches/brute_force_windows.spl`

Purpose: Highlight bursts of failed logons (EventCode 4625/4776) over five-minute windows. Tune `count > 20` per environment.

## Cowrie Activity

File: `detections/splunk/searches/cowrie_activity.spl`

Purpose: Track new Cowrie sessions and commands executed by adversaries. Use in conjunction with Wazuh alerts to provide analyst context.

## Deployment Notes

- Import SPL files as saved searches or dashboard panels.
- Ensure `index` values match your deployment (default example uses `main` or `wazuh` indexes).
- Set time range to real-time or rolling 24h for dashboards.
