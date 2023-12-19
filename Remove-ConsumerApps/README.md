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
