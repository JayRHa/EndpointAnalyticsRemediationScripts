<!-- jr-brand:start -->
<p align="center">
  <a href="https://jannikreinhard.com/">
    <img src="https://raw.githubusercontent.com/JayRHa/.github/main/assets/readme/brand-header.png" alt="Jannik Reinhard — I help enterprises ship secure AI agents" width="100%">
  </a>
</p>
<p align="center">
  <a href="https://jannikreinhard.com/">Website</a> ·
  <a href="https://www.linkedin.com/in/jannik-r/">LinkedIn</a> ·
  <a href="https://x.com/jannik_reinhard">X</a> ·
  <a href="https://www.youtube.com/@jannikreinhard">YouTube</a>
</p>
<!-- jr-brand:end -->

# Remove Consumer Apps

This script removes apps for all users by a given list of app names and app package names. It also removes the provisioned packages for new users.

## Usage/Examples

In **Remove-ConsumerAppsDetection.ps1** and **Remove-ConsumerAppsRemediation.ps1** change the list of apps to remove:

```powershell
$ConsumerApps = @{
    "Microsoft.XboxApp"                      = "Xbox App"
    "Microsoft.XboxGameOverlay"              = "Xbox Game Overlay"
    "Microsoft.Xbox.TCUI"                    = "Xbox TCUI"
    "Microsoft.MicrosoftSolitaireCollection" = "Solitaire Collection"
    "Microsoft.549981C3F5F10"                = "Cortana"
    "Vendor.Appname"                         = "My Custom App Name"
}
```

Import it a dectection script, make sure:

- Run this script using the logged-on credentials = No
- Run script in 64-bit PowerShell = Yes

Schedule it to run repeatedly, e.g. once

<!-- jr-brand-footer:start -->
---

[Articles and guides](https://jannikreinhard.com/) · [Repository index](https://github.com/JayRHa/.github/blob/main/REPOSITORIES.md)
<!-- jr-brand-footer:end -->
