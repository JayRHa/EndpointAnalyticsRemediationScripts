<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: install-cmtrace-remediate.ps1
Description: Installs CMTrace to c:\windows\system32
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

## Downlaod CMTracered from the following repository andd copy it in your own repo "https://github.com/andrew-s-taylor/public/raw/main/Troubleshooting/CMTrace.exe"
$ownRepoUri = "https://github.com/......."

invoke-webrequest -uri $ownRepoUri -outfile "C:\Windows\System32\cmtrace.exe"
