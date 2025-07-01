<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Uninstall-PrivateTeams
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

if ($null -eq (Get-AppxPackage -Name MicrosoftTeams -allusers)) {
	Write-Host "Private MS Teams client is not installed"
	exit 0
} Else {
	Write-Host "Private MS Teams client is installed"
	Exit 1
}
