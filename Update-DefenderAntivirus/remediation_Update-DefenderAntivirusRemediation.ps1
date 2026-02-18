<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Update-DefenderAntivirusRemediation
Description: Updates Windows Defender antivirus definitions
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    Update-MpSignature -ErrorAction Stop
    Write-Output "Defender definitions updated successfully."
    exit 0
}
catch {
    Write-Error "Failed to update Defender definitions: $_"
    exit 1
}
