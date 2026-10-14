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

<!-- jr-brand-footer:start -->
---

[Articles and guides](https://jannikreinhard.com/) · [Repository index](https://github.com/JayRHa/.github/blob/main/REPOSITORIES.md)
<!-- jr-brand-footer:end -->
