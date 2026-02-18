<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-legacytls.ps1
Description: Detects if legacy TLS 1.0 or TLS 1.1 protocols are enabled
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$NonCompliant = $false
$Protocols = @("TLS 1.0", "TLS 1.1")

foreach ($Protocol in $Protocols) {
    $ServerPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$Protocol\Server"
    $ClientPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$Protocol\Client"

    foreach ($Path in @($ServerPath, $ClientPath)) {
        if (Test-Path $Path) {
            $Enabled = Get-ItemProperty -Path $Path -Name "Enabled" -ErrorAction SilentlyContinue
            if ($null -eq $Enabled -or $Enabled.Enabled -ne 0) {
                $NonCompliant = $true
            }
        }
        else {
            $NonCompliant = $true
        }
    }
}

if ($NonCompliant) {
    Write-Warning "Not Compliant - Legacy TLS protocols are enabled"
    exit 1
}

Write-Output "Compliant - Legacy TLS protocols are disabled"
exit 0
