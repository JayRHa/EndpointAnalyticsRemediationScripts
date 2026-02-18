<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-diskspacetrend.ps1
Description: Detects if disk space is below 10% free
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MinFreePercent = 10

try {
    $Volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq "Fixed" -and $_.Size -gt 0 }
    $NonCompliant = $false

    foreach ($Vol in $Volumes) {
        $FreePercent = [math]::Round(($Vol.SizeRemaining / $Vol.Size) * 100, 2)
        $FreeGB = [math]::Round($Vol.SizeRemaining / 1GB, 2)

        if ($FreePercent -lt $MinFreePercent) {
            Write-Warning "Not Compliant - Drive $($Vol.DriveLetter): $FreePercent% free ($FreeGB GB)"
            $NonCompliant = $true
        }
    }

    if ($NonCompliant) { exit 1 }

    Write-Output "Compliant - All drives have sufficient free space"
    exit 0
}
catch {
    Write-Warning "Error checking disk space: $_"
    exit 1
}
