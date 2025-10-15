# Microsoft Sentinel Queries

## Risky Sign-ins

File: `detections/sentinel/kql/risky_signins.kql`

Highlights non-successful sign-in results grouped by user, app, and location to surface credential stuffing campaigns or impossible travel scenarios.

## DMZ Egress Blocks

File: `detections/sentinel/kql/dmz_egress_blocks.kql`

Correlates firewall deny events from pfSense forwarded via Sentinel data connectors to ensure DMZ segmentation is effective.

## Usage Tips

- Store KQL snippets in a shared Sentinel workspace as Query Packs.
- Tag queries with MITRE tactics to align with the control matrix.
- Pair with automation rules to create incidents when thresholds are exceeded.
