# WH4B - Last Used Method

This script is used to detect the last used method for Windows Hello for Business. It is a detect-only script.

Normal states (exit 0)

- `Pin authentication`
- `Fingerprint authentication`
- `Facial authentication`
- `Password authentication`
- `FIDO authentication`

Error states: (exit 1)

- `LastLoggedOnProvider Value is not there`
- `Authentication method cannot be checked`
- `Something went wrong:`

## Usage/Examples

In **detect.ps1** change the ```$LogDirSubFolderName = "YOURFOLDERNAME"```. Import it a dectection script, make sure:

- Run this script using the logged-on credentials = Yes
- Run script in 64-bit PowerShell = Yes

Schedule it to run repeatedly, e.g. daily.

## Troubleshooting/Logs

The log file is created in the users temp folder, e.g. `C:\Users\username\AppData\Local\Temp\YOURFOLDERNAME\_WHfB_lastused_method.log`
