<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: rotate-localadminpassword.ps1
Description: Rotates the local administrator password with a random secure password
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $AdminAccount = Get-LocalUser | Where-Object { $_.SID -like "S-1-5-*-500" }
    if (-not $AdminAccount) {
        Write-Error "Local administrator account not found"
        exit 1
    }

    Add-Type -AssemblyName System.Web
    $NewPassword = [System.Web.Security.Membership]::GeneratePassword(24, 6)
    $SecurePassword = ConvertTo-SecureString $NewPassword -AsPlainText -Force

    $AdminAccount | Set-LocalUser -Password $SecurePassword -ErrorAction Stop
    Write-Output "Local administrator password has been rotated successfully"
    exit 0
}
catch {
    Write-Error "Failed to rotate password: $_"
    exit 1
}
