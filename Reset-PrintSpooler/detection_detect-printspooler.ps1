<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-printspooler.ps1
Description: Detects if the Print Spooler has stuck jobs or is not running
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $SpoolerService = Get-Service -Name Spooler -ErrorAction Stop
    if ($SpoolerService.Status -ne "Running") {
        Write-Warning "Not Compliant - Print Spooler is not running"
        exit 1
    }

    $SpoolPath = "$env:SystemRoot\System32\spool\PRINTERS"
    if (Test-Path $SpoolPath) {
        $StuckJobs = (Get-ChildItem -Path $SpoolPath -ErrorAction SilentlyContinue).Count
        if ($StuckJobs -gt 0) {
            Write-Warning "Not Compliant - $StuckJobs stuck print jobs found"
            exit 1
        }
    }

    Write-Output "Compliant - Print Spooler is running with no stuck jobs"
    exit 0
}
catch {
    Write-Warning "Error checking Print Spooler: $_"
    exit 1
}
