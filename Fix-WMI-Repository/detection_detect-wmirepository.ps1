<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-wmirepository.ps1
Description: Detects if the WMI repository is corrupted
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $WmiResult = winmgmt /verifyrepository 2>&1
    if ($WmiResult -match "consistent|is consistent") {
        Write-Output "Compliant - WMI repository is consistent"
        exit 0
    }

    Write-Warning "Not Compliant - WMI repository is inconsistent: $WmiResult"
    exit 1
}
catch {
    Write-Warning "Not Compliant - Error checking WMI repository: $_"
    exit 1
}
