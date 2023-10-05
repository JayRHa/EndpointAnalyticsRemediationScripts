# WH4B - Enrolled Methods

This script detects the Windows Hello for Business enrolled/configured methods and outputs them as Pre-remediation detection output.
The output can be any of these states:

Normal states (exit 0)

- `PIN configured`
- `Face and Fingerprint configured`
- `Face configured`
- `Fingerprint configured`
- `Windows Hello not configured`

>If a biometric is configured a PIN is also configured. If a PIN is configured a biometric is not necessarily configured.

Error states: (exit 1)

- `LogonCredsAvailable Value is not there`
- `Unknown Biometric configured`
- `Something went wrong`
- `Uncaught error`

## Usage/Examples

In **detect.ps1** change the ```$LogDirSubFolderName = "YOURFOLDERNAME"```. Import it a dectection script, make sure:

- Run this script using the logged-on credentials = Yes
- Run script in 64-bit PowerShell = Yes

Schedule it to run repeatedly, e.g. daily.

## Troubleshooting/Logs

The log file is created in the users temp folder, e.g. `C:\Users\username\AppData\Local\Temp\YOURFOLDERNAME\_WHfB_enrolled_method.log`
