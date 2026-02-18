<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-certificateexpiry.ps1
Description: Detects certificates expiring within the next 30 days
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$DaysBeforeExpiry = 30

try {
    $ExpiryDate = (Get-Date).AddDays($DaysBeforeExpiry)

    $ExpiringCerts = Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction Stop |
        Where-Object { $_.NotAfter -lt $ExpiryDate -and $_.NotAfter -gt (Get-Date) }

    $ExpiredCerts = Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction Stop |
        Where-Object { $_.NotAfter -lt (Get-Date) }

    if ($ExpiredCerts.Count -gt 0 -or $ExpiringCerts.Count -gt 0) {
        Write-Warning "Not Compliant - $($ExpiredCerts.Count) expired, $($ExpiringCerts.Count) expiring soon"
        exit 1
    }

    Write-Output "Compliant - No certificates expiring within $DaysBeforeExpiry days"
    exit 0
}
catch {
    Write-Warning "Error checking certificates: $_"
    exit 1
}
