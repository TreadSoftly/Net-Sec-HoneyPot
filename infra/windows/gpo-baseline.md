# GPO Baseline

## Audit Policy

- Enable Advanced Audit Policy Configuration:
  - Account Logon: Success and Failure
  - Logon/Logoff: Success and Failure
  - Object Access: Failure
  - Policy Change: Success

## Sysmon Integration

- Deploy Sysmon config via startup script or GPO scheduled task (see `infra/windows/sysmon.md`).
- Ensure Event Forwarding to Wazuh via agent.

## RDP Controls

- Allow RDP only from `10.10.0.0/24`.
- Set Network Level Authentication enforced.
- Configure lockout policy: 5 attempts, 15-minute reset.

## Firewall

- Enable Windows Defender Firewall on Domain profile.
- Allow Wazuh agent traffic (TCP 1514 outbound).
- Restrict SMB to LAN subnets only.

## Local Policies

- Disable anonymous SID/Name translation.
- Require strong session security for SMB.
- Enforce UAC for administrators.

## Deployment Steps

1. Create new GPO `Baseline-Security`.
2. Link to `lab.local` domain root.
3. Use Group Policy Management Editor to configure policies above.
4. Run `gpupdate /force` on domain members and validate via `rsop.msc`.
