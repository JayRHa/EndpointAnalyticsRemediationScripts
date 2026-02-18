<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: remove-expiredcertificates.ps1
Description: Removes expired certificates from the local machine store
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $ExpiredCerts = Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction Stop |
        Where-Object { $_.NotAfter -lt (Get-Date) }

    $Removed = 0
    foreach ($Cert in $ExpiredCerts) {
        Remove-Item -Path "Cert:\LocalMachine\My\$($Cert.Thumbprint)" -Force -ErrorAction Stop
        Write-Output "Removed expired certificate: $($Cert.Subject)"
        $Removed++
    }

    Write-Output "Removed $Removed expired certificates"
    exit 0
}
catch {
    Write-Error "Failed to remove expired certificates: $_"
    exit 1
}
