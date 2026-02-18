<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: fix-wmirepository.ps1
Description: Repairs the WMI repository if corrupted
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Result = winmgmt /salvagerepository 2>&1
    Write-Output "Salvage result: $Result"

    $VerifyResult = winmgmt /verifyrepository 2>&1
    if ($VerifyResult -match "consistent|is consistent") {
        Write-Output "WMI repository repaired via salvage"
        exit 0
    }

    $ResetResult = winmgmt /resetrepository 2>&1
    Write-Output "Reset result: $ResetResult"

    $FinalVerify = winmgmt /verifyrepository 2>&1
    if ($FinalVerify -match "consistent|is consistent") {
        Write-Output "WMI repository repaired via reset"
        exit 0
    }

    Write-Error "WMI repository could not be repaired"
    exit 1
}
catch {
    Write-Error "Failed to repair WMI repository: $_"
    exit 1
}
