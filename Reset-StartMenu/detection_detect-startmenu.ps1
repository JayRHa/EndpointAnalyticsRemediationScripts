<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-startmenu.ps1
Description: Detects if the Start Menu database is corrupted or oversized
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxSizeMB = 50

try {
    $UserProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue
    $NonCompliant = $false

    foreach ($Profile in $UserProfiles) {
        $TileDataPath = Join-Path $Profile.FullName "AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy"
        if (Test-Path $TileDataPath) {
            $Size = (Get-ChildItem -Path $TileDataPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $SizeMB = [math]::Round($Size / 1MB, 2)
            if ($SizeMB -gt $MaxSizeMB) {
                Write-Warning "Not Compliant - Start Menu data for $($Profile.Name) is $SizeMB MB"
                $NonCompliant = $true
            }
        }
    }

    if ($NonCompliant) { exit 1 }

    Write-Output "Compliant - Start Menu data is within normal limits"
    exit 0
}
catch {
    Write-Warning "Error checking Start Menu: $_"
    exit 1
}
