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

	# Maximum number of packages to upgrade per run (to avoid Intune 3600s timeout)
	$MaxPackagesPerRun = 5

	# Chocolatey Path
	$script:choco = "C:\ProgramData\chocolatey\choco.exe"

	# Get all choco programs 2 upgrade
	$choco2upgrade_all = &$choco outdated -r | Where-Object {$_ -notin $upgrade_excludes}

	# select ids and remove excludes
	$choco2upgrade_selected = @()
	foreach($id in $choco2upgrade_all){
		$pos = $id.IndexOf("|")
		if($pos -le 0){ continue }
		$idonly = $id.Substring(0, $pos)
		if($idonly -notin $upgrade_excludes){
			$choco2upgrade_selected += $idonly
		}
	}

	# Limit number of packages to avoid timeout
	if ($choco2upgrade_selected.Count -gt $MaxPackagesPerRun) {
		Write-Output "Limiting upgrade to $MaxPackagesPerRun of $($choco2upgrade_selected.Count) packages to avoid timeout."
		$choco2upgrade_selected = $choco2upgrade_selected | Select-Object -First $MaxPackagesPerRun
	}

	if ($choco2upgrade_selected) {
		foreach ($pkg in $choco2upgrade_selected) {
			Write-Output "Upgrading: $pkg"
			&$choco upgrade $pkg -y --no-progress --limit-output 2>&1
		}
	}
	else {
		Write-Output "No upgrades available."
	}

}catch{
	Write-Error "Error upgrading apps: $_"
}
