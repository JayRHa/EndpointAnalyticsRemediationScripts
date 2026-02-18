<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: reset-networkstack.ps1
Description: Resets the complete network stack (Winsock, IP, DNS)
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    netsh winsock reset 2>$null | Out-Null
    Write-Output "Winsock reset completed"

    netsh int ip reset 2>$null | Out-Null
    Write-Output "IP stack reset completed"

    ipconfig /flushdns 2>$null | Out-Null
    Write-Output "DNS cache flushed"

    ipconfig /release 2>$null | Out-Null
    ipconfig /renew 2>$null | Out-Null
    Write-Output "IP address released and renewed"

    Write-Output "Network stack has been reset. A reboot is recommended."
    exit 0
}
catch {
    Write-Error "Failed to reset network stack: $_"
    exit 1
}
