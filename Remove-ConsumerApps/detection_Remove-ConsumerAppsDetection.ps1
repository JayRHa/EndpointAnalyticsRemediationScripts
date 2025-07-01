<#
Version: 1.0
Author: 
- Marius Wyss (marius.wyss@microsoft.com)
Script: Remove-ConsumerAppsDetection.ps1
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

$ConsumerApps = @{
    "Microsoft.XboxApp" = "Xbox App"
    "Microsoft.XboxGameOverlay" = "Xbox Game Overlay"
    "Microsoft.Xbox.TCUI" = "Xbox TCUI"
    "Microsoft.MicrosoftSolitaireCollection" = "Solitaire Collection"
    "Microsoft.549981C3F5F10" = "Cortana"
}

# Check if any of the Consumer Apps are installed
$UninstallPackages = $ConsumerApps.Keys

$InstalledPackages = Get-AppxPackage -AllUsers | Where { ($UninstallPackages -contains $_.Name) }

If ($InstalledPackages -eq $null) {
    Write-Output "No Consumer Apps installed"
    Exit 0
}

If ($InstalledPackages -ne $null) {
    $out = "Consumer Apps installed: ({0})" -f $($($ConsumerApps[$InstalledPackages.Name]) -join ', ')
    Write-Output $out
    Exit 1
}
