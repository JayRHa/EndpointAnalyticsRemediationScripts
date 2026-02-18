<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-bluescreenhistory.ps1
Description: Detects BSOD occurrences in the last 30 days
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$DaysBack = 30

try {
    $StartTime = (Get-Date).AddDays(-$DaysBack)

    $BSODs = Get-WinEvent -FilterHashtable @{
        LogName      = 'System'
        Id           = 1001
        ProviderName = 'Microsoft-Windows-WER-SystemErrorReporting'
        StartTime    = $StartTime
    } -ErrorAction SilentlyContinue

    $BSODCount = ($BSODs | Measure-Object).Count

    if ($BSODCount -gt 0) {
        Write-Warning "Not Compliant - $BSODCount BSOD(s) in the last $DaysBack days"
        exit 1
    }

    $MiniDumps = Get-ChildItem -Path "$env:SystemRoot\Minidump" -Filter "*.dmp" -ErrorAction SilentlyContinue |
        Where-Object { $_.CreationTime -gt $StartTime }

    if ($MiniDumps.Count -gt 0) {
        Write-Warning "Not Compliant - $($MiniDumps.Count) minidump files found"
        exit 1
    }

    Write-Output "Compliant - No BSODs in the last $DaysBack days"
    exit 0
}
catch {
    Write-Warning "Error checking BSOD history: $_"
    exit 1
}
