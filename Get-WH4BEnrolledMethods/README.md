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

<!-- jr-brand-footer:start -->
---

[Articles and guides](https://jannikreinhard.com/) · [Repository index](https://github.com/JayRHa/.github/blob/main/REPOSITORIES.md)
<!-- jr-brand-footer:end -->
