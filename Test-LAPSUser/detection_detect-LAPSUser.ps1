<#
Version: 1.0
Author:
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Sascha Stumpler (sastu@master-client.com)
Script: detect-LAPSUser
Description: Checks if a user exists if LAPS is configured to use a custom username, laps is installed and a Backup Directory configured
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User/Admin
Context: 32 & 64 Bit
#>

$AdminAccountName = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Policies\LAPS' -Name 'AdministratorAccountName' -ErrorAction SilentlyContinue).AdministratorAccountName
$item = Get-LocalUser -Name $AdminAccountName -ErrorAction SilentlyContinue

if ($null -eq $item -and $null -ne $AdminAccountName -and ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\LAPS' -Name 'BackupDirectory' -ErrorAction SilentlyContinue).BackupDirectory) -ne '0' -and (Get-Item -Path ($env:windir + '\system32\laps.dll') -ErrorAction SilentlyContinue)) {
    exit 1
}else{
    exit 0
}
