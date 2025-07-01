<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: remediation-choco-upgrade
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

try{
	$upgrade_excludes = "snagit", "example2"

	# Chocolatey Path
	$script:choco = "C:\ProgramData\chocolatey\choco.exe"

	# Get all choco programs 2 upgrade
	$choco2upgrade_all = &$choco outdated -r | Where-Object {$_ -notin $upgrade_excludes}

	# select ids and remove excludes
	$choco2upgrade_selected = @()
	foreach($id in $choco2upgrade_all){
		$pos = $id.IndexOf("|")
		$idonly = $id.Substring(0, $pos)
		if($idonly -notin $upgrade_excludes){
			$choco2upgrade_selected += $idonly
		}
	}


	if ($choco2upgrade_selected) {
		Write-Output "Upgrading now: $choco2upgrade_selected"
		&$choco upgrade $choco2upgrade_selected
	}
	else {
		Write-Output "No upgrades aviable."
	}

}catch{
	Write-Error "Error reading apps: $_"
}
