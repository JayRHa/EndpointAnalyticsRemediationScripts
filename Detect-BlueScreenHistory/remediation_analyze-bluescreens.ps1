<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: analyze-bluescreens.ps1
Description: Analyzes BSODs and runs system file checks
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $ReportDir = "$env:ProgramData\BSODAnalysis"
    if (-not (Test-Path $ReportDir)) { New-Item -Path $ReportDir -ItemType Directory -Force | Out-Null }

    $ReportFile = Join-Path $ReportDir "bsod-report_$(Get-Date -Format 'yyyyMMdd').txt"
    "BSOD Analysis Report - $(Get-Date)" | Out-File $ReportFile

    $BSODs = Get-WinEvent -FilterHashtable @{
        LogName      = 'System'
        Id           = 1001
        ProviderName = 'Microsoft-Windows-WER-SystemErrorReporting'
        StartTime    = (Get-Date).AddDays(-30)
    } -ErrorAction SilentlyContinue

    if ($BSODs) {
        $BSODs | ForEach-Object {
            "Time: $($_.TimeCreated) - $($_.Message.Substring(0, [Math]::Min(200, $_.Message.Length)))" | Out-File $ReportFile -Append
        }
    }

    Write-Output "Running System File Checker..."
    sfc /scannow 2>&1 | Out-File $ReportFile -Append

    Write-Output "Running DISM health restore..."
    DISM /Online /Cleanup-Image /RestoreHealth 2>&1 | Out-File $ReportFile -Append

    Write-Output "BSOD analysis complete. Report: $ReportFile"
    exit 0
}
catch {
    Write-Error "Failed to analyze BSODs: $_"
    exit 1
}
