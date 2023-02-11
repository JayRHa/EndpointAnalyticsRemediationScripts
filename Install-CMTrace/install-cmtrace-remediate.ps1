<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: install-cmtrace-remediate.ps1
Description: Installs CMTrace to c:\windows\system32
Release notes:
Version 1.0: Init
#> 
invoke-webrequest -uri "https://github.com/andrew-s-taylor/public/raw/main/Troubleshooting/CMTrace.exe" -outfile "C:\Windows\System32\cmtrace.exe"
