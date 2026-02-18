<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: BlackLotus-MitigationDetection
Description: Detects if the system is vulnerable to the BlackLotus (CVE-2023-24932) Secure Boot bypass
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Vulnerable = $false
    $Issues = @()

    # Check if Secure Boot is enabled
    try {
        $SecureBoot = Confirm-SecureBootUEFI -ErrorAction Stop
        if (-not $SecureBoot) {
            $Issues += "Secure Boot is disabled"
            $Vulnerable = $true
        }
    }
    catch {
        $Issues += "Secure Boot check failed (BIOS mode or not supported)"
    }

    # Check for the KB5025885 mitigation registry key
    $MitigationPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
    $AvailableUpdates = (Get-ItemProperty -Path $MitigationPath -Name "AvailableUpdates" -ErrorAction SilentlyContinue).AvailableUpdates

    # Value 0x40 (64) indicates the revocation has been applied
    if (-not $AvailableUpdates -or ($AvailableUpdates -band 0x40) -ne 0x40) {
        $Issues += "BlackLotus Secure Boot revocation not applied"
        $Vulnerable = $true
    }

    # Check the boot manager revocation list (DBX)
    $DBXPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State"
    $UEFISecureBootState = (Get-ItemProperty -Path $DBXPath -Name "UEFISecureBootEnabled" -ErrorAction SilentlyContinue).UEFISecureBootEnabled

    if ($Vulnerable) {
        Write-Output "System may be vulnerable to BlackLotus: $($Issues -join ' | ')"
        exit 1
    }
    else {
        Write-Output "System is protected against BlackLotus (CVE-2023-24932)."
        exit 0
    }
}
catch {
    Write-Error "Failed to check BlackLotus vulnerability status: $_"
    exit 1
}
