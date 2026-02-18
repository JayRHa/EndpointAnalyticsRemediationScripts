<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-credentialguard.ps1
Description: Detects if Credential Guard is enabled
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $DevGuard = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard -ErrorAction Stop
    if ($DevGuard.SecurityServicesRunning -contains 1) {
        Write-Output "Compliant - Credential Guard is running"
        exit 0
    }

    Write-Warning "Not Compliant - Credential Guard is not running"
    exit 1
}
catch {
    Write-Warning "Not Compliant - Unable to check Credential Guard: $_"
    exit 1
}
