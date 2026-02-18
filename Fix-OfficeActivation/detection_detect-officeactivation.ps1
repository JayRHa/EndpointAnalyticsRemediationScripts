<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-officeactivation.ps1
Description: Detects if Microsoft Office is properly activated
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $OfficePaths = @(
        "C:\Program Files\Microsoft Office\Office16\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs",
        "C:\Program Files\Microsoft Office\root\Office16\ospp.vbs"
    )

    foreach ($OSPPPath in $OfficePaths) {
        if (Test-Path $OSPPPath) {
            $Result = cscript //nologo $OSPPPath /dstatus 2>$null
            if ($Result -match "LICENSE STATUS.*---LICENSED---") {
                Write-Output "Compliant - Office is activated"
                exit 0
            }
            else {
                Write-Warning "Not Compliant - Office is not properly activated"
                exit 1
            }
        }
    }

    Write-Output "Compliant - Office not installed or path not found"
    exit 0
}
catch {
    Write-Warning "Error checking Office activation: $_"
    exit 1
}
