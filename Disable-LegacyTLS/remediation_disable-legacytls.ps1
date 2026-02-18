<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: disable-legacytls.ps1
Description: Disables TLS 1.0 and TLS 1.1 protocols
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Protocols = @("TLS 1.0", "TLS 1.1")

    foreach ($Protocol in $Protocols) {
        foreach ($Type in @("Server", "Client")) {
            $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$Protocol\$Type"
            if (-not (Test-Path $Path)) {
                New-Item -Path $Path -Force | Out-Null
            }
            New-ItemProperty -Path $Path -Name "Enabled" -Value 0 -PropertyType DWord -Force | Out-Null
            New-ItemProperty -Path $Path -Name "DisabledByDefault" -Value 1 -PropertyType DWord -Force | Out-Null
        }
    }

    Write-Output "Legacy TLS protocols disabled successfully"
    exit 0
}
catch {
    Write-Error "Failed to disable legacy TLS: $_"
    exit 1
}
