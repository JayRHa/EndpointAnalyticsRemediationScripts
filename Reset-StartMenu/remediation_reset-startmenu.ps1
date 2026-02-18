<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: reset-startmenu.ps1
Description: Resets the Start Menu layout and database
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    Get-AppxPackage -AllUsers Microsoft.Windows.StartMenuExperienceHost | ForEach-Object {
        Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppxManifest.xml" -ErrorAction SilentlyContinue
    }

    Get-AppxPackage -AllUsers Microsoft.Windows.ShellExperienceHost | ForEach-Object {
        Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppxManifest.xml" -ErrorAction SilentlyContinue
    }

    Write-Output "Start Menu has been reset successfully"
    exit 0
}
catch {
    Write-Error "Failed to reset Start Menu: $_"
    exit 1
}
