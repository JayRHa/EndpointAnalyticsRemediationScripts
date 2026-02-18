<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-searchindex.ps1
Description: Detects if Windows Search indexing is working properly
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $SearchService = Get-Service -Name WSearch -ErrorAction Stop
    if ($SearchService.Status -ne "Running") {
        Write-Warning "Not Compliant - Windows Search service is not running"
        exit 1
    }

    $IndexPath = "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb"
    if (Test-Path $IndexPath) {
        $IndexSizeMB = [math]::Round((Get-Item $IndexPath).Length / 1MB, 2)
        if ($IndexSizeMB -gt 5120) {
            Write-Warning "Not Compliant - Search index is unusually large: $IndexSizeMB MB"
            exit 1
        }
    }

    Write-Output "Compliant - Windows Search is functioning normally"
    exit 0
}
catch {
    Write-Warning "Error checking search index: $_"
    exit 1
}
