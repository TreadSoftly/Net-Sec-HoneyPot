# Local Administrator Password Solution (LAPS)

## Overview

Microsoft LAPS rotates local admin passwords and stores them securely in AD. This lab uses the modern LAPS (Windows LAPS) available in Server 2022/Windows 11.

## Enable Directory Schema

On DC1:

```powershell
Update-LapsADSchema
```

Verify attributes `msLAPS-Password` exist in AD schema.

## Group Policy Configuration

1. Create GPO `LAPS-Policy`.
2. Configure under **Computer Configuration > Policies > Administrative Templates > System > LAPS**:
   - Enable password backup.
   - Set password complexity to `Large letters + small letters + numbers + special characters`.
   - Password length: 24.
   - Password age: 7 days.
   - Post-authentication actions: Reset the password and logoff the managed account.
3. Link GPO to OU containing Windows 11 endpoints.

## Permissions

- Create security group `LAPS Readers`.
- Delegate `Read msLAPS-Password` permission to the group on target computer objects.
- Restrict `Reset password` rights to Domain Admins or SOC admins as required.

## Verification

On Windows 11 endpoint:

```powershell
Get-LapsADPassword -Identity WIN11-01
```

Ensure password retrieval is limited to authorized operators.
