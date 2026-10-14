# Import remediation scripts

Select the folders and review their scripts, run-as context and settings first. The tool creates packages only; it never assigns them or executes their contents. It skips names already present in Intune and refuses ambiguous script pairs. A run can partially complete if Graph fails; rerun to skip already-created names. Avoid concurrent imports with the same names.

```powershell
# Offline preview; no credentials or Graph connection needed.
./tools/Import-RemediationScripts.ps1 -Name 'Activate-Numlock' -WhatIf

Install-Module Microsoft.Graph.Authentication -Scope CurrentUser
Connect-MgGraph -Scopes DeviceManagementScripts.ReadWrite.All
./tools/Import-RemediationScripts.ps1 -Name 'Activate-Numlock' -Confirm

# Explicit opt-in for all valid pairs; preview first.
./tools/Import-RemediationScripts.ps1 -All -WhatIf
```

The signed-in operator needs Intune access and consent for the delegated permission. Existing profiles are not updated; differing files with the same name require manual review. Use `-RunAsAccount user`, `-RunAs32Bit`, `-EnforceSignatureCheck` and `-Publisher` only as required by the selected package. Defaults are SYSTEM, 64-bit and no signature enforcement, so unsigned repository samples can be imported. Imports do not make every sample appropriate for your environment.

[Microsoft Graph create deviceHealthScript](https://learn.microsoft.com/en-us/graph/api/intune-devices-devicehealthscript-create?view=graph-rest-beta). This beta endpoint can change. Live Intune import requires a separate tenant validation; local tests mock Graph.
