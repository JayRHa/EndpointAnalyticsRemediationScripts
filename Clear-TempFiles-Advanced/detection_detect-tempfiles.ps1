<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-tempfiles.ps1
Description: Detects if temporary files exceed 2GB in total
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxSizeMB = 2048

try {
    $TempPaths = @(
        "$env:SystemRoot\Temp",
        "$env:SystemRoot\Logs\CBS",
        "$env:SystemRoot\Logs\DISM",
        "$env:SystemRoot\Minidump",
        "$env:SystemRoot\Prefetch"
    )

    $TotalSize = 0
    foreach ($Path in $TempPaths) {
        if (Test-Path $Path) {
            $Size = (Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $TotalSize += $Size
        }
    }

    $TotalSizeMB = [math]::Round($TotalSize / 1MB, 2)
    if ($TotalSizeMB -gt $MaxSizeMB) {
        Write-Warning "Not Compliant - Temp files total: $TotalSizeMB MB"
        exit 1
    }

    Write-Output "Compliant - Temp files total: $TotalSizeMB MB"
    exit 0
}
catch {
    Write-Warning "Error checking temp files: $_"
    exit 1
}
