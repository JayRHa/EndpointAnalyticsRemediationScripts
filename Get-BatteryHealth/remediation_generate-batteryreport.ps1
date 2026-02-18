<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: generate-batteryreport.ps1
Description: Generates a battery health report and applies power optimizations
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $ReportDir = "$env:ProgramData\BatteryHealth"
    if (-not (Test-Path $ReportDir)) { New-Item -Path $ReportDir -ItemType Directory -Force | Out-Null }

    $ReportFile = Join-Path $ReportDir "battery-report_$(Get-Date -Format 'yyyyMMdd').html"
    powercfg /batteryreport /output $ReportFile 2>$null
    Write-Output "Battery report saved to: $ReportFile"

    powercfg /change monitor-timeout-dc 5
    powercfg /change standby-timeout-dc 15
    powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 20

    Write-Output "Battery optimization settings applied"
    exit 0
}
catch {
    Write-Error "Failed to generate battery report: $_"
    exit 1
}
