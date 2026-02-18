<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: enforce-bitlocker.ps1
Description: Enables BitLocker on the OS drive with TPM protector
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $TPM = Get-Tpm -ErrorAction Stop
    if (-not $TPM.TpmPresent -or -not $TPM.TpmReady) {
        Write-Error "TPM is not present or not ready. BitLocker cannot be enabled."
        exit 1
    }

    $BitLockerVolume = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop
    if ($BitLockerVolume.ProtectionStatus -eq "On") {
        Write-Output "BitLocker is already enabled"
        exit 0
    }

    Enable-BitLocker -MountPoint $env:SystemDrive -EncryptionMethod XtsAes256 -TpmProtector -SkipHardwareTest -ErrorAction Stop
    Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -RecoveryPasswordProtector -ErrorAction Stop

    Write-Output "BitLocker has been enabled successfully"
    exit 0
}
catch {
    Write-Error "Failed to enable BitLocker: $_"
    exit 1
}
