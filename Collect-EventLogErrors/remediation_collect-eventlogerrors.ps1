<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: collect-eventlogerrors.ps1
Description: Collects and exports critical event log entries for analysis
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$HoursBack = 24
$ExportPath = "$env:ProgramData\EventLogReport"

try {
    if (-not (Test-Path $ExportPath)) { New-Item -Path $ExportPath -ItemType Directory -Force | Out-Null }

    $StartTime = (Get-Date).AddHours(-$HoursBack)
    $Events = Get-WinEvent -FilterHashtable @{
        LogName   = 'System', 'Application'
        Level     = 1, 2
        StartTime = $StartTime
    } -ErrorAction SilentlyContinue

    $ReportFile = Join-Path $ExportPath "EventReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    $Events | Select-Object TimeCreated, LevelDisplayName, ProviderName, Id, Message |
        Export-Csv -Path $ReportFile -NoTypeInformation -Encoding UTF8

    Get-ChildItem -Path $ExportPath -Filter "EventReport_*.csv" |
        Sort-Object CreationTime -Descending | Select-Object -Skip 7 |
        Remove-Item -Force -ErrorAction SilentlyContinue

    Write-Output "Event log report saved to: $ReportFile"
    exit 0
}
catch {
    Write-Error "Failed to collect event logs: $_"
    exit 1
}
