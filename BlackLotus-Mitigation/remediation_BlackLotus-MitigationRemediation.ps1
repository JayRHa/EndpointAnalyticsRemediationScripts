<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: BlackLotus-MitigationRemediation
Description: Applies BlackLotus (CVE-2023-24932) mitigation by enabling the Secure Boot revocation
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
IMPORTANT: Ensure KB5025885 or later is installed before running this script. Applying the revocation without the update may render the device unbootable.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    # Step 1: Verify Secure Boot is enabled
    try {
        $SecureBoot = Confirm-SecureBootUEFI -ErrorAction Stop
        if (-not $SecureBoot) {
            Write-Error "Secure Boot is not enabled. Enable Secure Boot in BIOS before applying mitigation."
            exit 1
        }
    }
    catch {
        Write-Error "Cannot verify Secure Boot status. This system may not support UEFI."
        exit 1
    }

    # Step 2: Apply the revocation by setting the registry key
    $MitigationPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"

    if (-not (Test-Path $MitigationPath)) {
        Write-Error "SecureBoot registry path not found."
        exit 1
    }

    # Set AvailableUpdates to trigger the Code Integrity Boot Policy update
    $CurrentValue = (Get-ItemProperty -Path $MitigationPath -Name "AvailableUpdates" -ErrorAction SilentlyContinue).AvailableUpdates
    if (-not $CurrentValue) { $CurrentValue = 0 }

    # Enable the mitigation flags: 0x10 (Code Integrity) + 0x20 (Boot Manager) + 0x40 (Revocation)
    $NewValue = $CurrentValue -bor 0x70
    Set-ItemProperty -Path $MitigationPath -Name "AvailableUpdates" -Value $NewValue -Type DWord -Force

    Write-Output "BlackLotus mitigation registry keys applied. A reboot is required to complete the process."
    Write-Output "IMPORTANT: The system will need multiple reboots to fully apply the Secure Boot DBX revocation."
    exit 0
}
catch {
    Write-Error "Failed to apply BlackLotus mitigation: $_"
    exit 1
}
