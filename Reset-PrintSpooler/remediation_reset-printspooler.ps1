<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: reset-printspooler.ps1
Description: Resets the Print Spooler service and clears stuck print jobs
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    Stop-Service -Name Spooler -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    $SpoolPath = "$env:SystemRoot\System32\spool\PRINTERS"
    if (Test-Path $SpoolPath) {
        Remove-Item -Path "$SpoolPath\*" -Force -ErrorAction SilentlyContinue
    }

    Start-Service -Name Spooler -ErrorAction Stop
    Write-Output "Print Spooler has been reset successfully"
    exit 0
}
catch {
    Write-Error "Failed to reset Print Spooler: $_"
    exit 1
}
