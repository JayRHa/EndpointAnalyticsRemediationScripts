<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Update-DefenderAntivirusDetection
Description: Detects if Windows Defender antivirus definitions are outdated
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

# Maximum age of definitions in days
$MaxDefinitionAgeDays = 3

try {
    $DefenderStatus = Get-MpComputerStatus -ErrorAction Stop
    $DefinitionAge = (New-TimeSpan -Start $DefenderStatus.AntivirusSignatureLastUpdated -End (Get-Date)).Days

    if ($DefinitionAge -gt $MaxDefinitionAgeDays) {
        Write-Output "Defender definitions are $DefinitionAge days old (threshold: $MaxDefinitionAgeDays days)"
        exit 1
    }
    else {
        Write-Output "Defender definitions are up to date ($DefinitionAge days old)"
        exit 0
    }
}
catch {
    Write-Error "Failed to check Defender status: $_"
    exit 1
}
