<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-localadminpasswordage.ps1
Description: Detects if the local administrator password is older than 90 days
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxPasswordAgeDays = 90

try {
    $AdminAccount = Get-LocalUser | Where-Object { $_.SID -like "S-1-5-*-500" }
    if (-not $AdminAccount) {
        Write-Warning "Not Compliant - Local administrator account not found"
        exit 1
    }

    $PasswordLastSet = $AdminAccount.PasswordLastSet
    if (-not $PasswordLastSet) {
        Write-Warning "Not Compliant - Password has never been set"
        exit 1
    }

    $PasswordAge = (Get-Date) - $PasswordLastSet
    if ($PasswordAge.Days -gt $MaxPasswordAgeDays) {
        Write-Warning "Not Compliant - Password is $($PasswordAge.Days) days old (max: $MaxPasswordAgeDays)"
        exit 1
    }

    Write-Output "Compliant - Password is $($PasswordAge.Days) days old"
    exit 0
}
catch {
    Write-Warning "Not Compliant - Error: $_"
    exit 1
}
