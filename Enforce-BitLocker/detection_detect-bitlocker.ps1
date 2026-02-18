<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-bitlocker.ps1
Description: Detects if BitLocker is enabled on the OS drive
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $BitLockerVolume = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop
    if ($BitLockerVolume.ProtectionStatus -eq "On" -and $BitLockerVolume.EncryptionPercentage -eq 100) {
        Write-Output "Compliant - BitLocker is enabled and fully encrypted"
        exit 0
    }
    Write-Warning "Not Compliant - BitLocker protection status: $($BitLockerVolume.ProtectionStatus), Encryption: $($BitLockerVolume.EncryptionPercentage)%"
    exit 1
}
catch {
    Write-Warning "Not Compliant - BitLocker not available or error: $_"
    exit 1
}
