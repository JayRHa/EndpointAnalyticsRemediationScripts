<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-batteryhealth.ps1
Description: Detects battery health status on laptops
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MinHealthPercent = 40

try {
    $Battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue
    if (-not $Battery) {
        Write-Output "Compliant - No battery detected (desktop)"
        exit 0
    }

    $ReportPath = "$env:TEMP\battery-report.xml"
    powercfg /batteryreport /xml /output $ReportPath 2>$null

    if (Test-Path $ReportPath) {
        [xml]$Report = Get-Content $ReportPath
        $DesignCapacity = $Report.BatteryReport.Batteries.Battery.DesignCapacity
        $FullChargeCapacity = $Report.BatteryReport.Batteries.Battery.FullChargeCapacity

        if ($DesignCapacity -and $FullChargeCapacity -and $DesignCapacity -gt 0) {
            $HealthPercent = [math]::Round(($FullChargeCapacity / $DesignCapacity) * 100, 2)
            Remove-Item -Path $ReportPath -Force -ErrorAction SilentlyContinue

            if ($HealthPercent -lt $MinHealthPercent) {
                Write-Warning "Not Compliant - Battery health: $HealthPercent%"
                exit 1
            }

            Write-Output "Compliant - Battery health: $HealthPercent%"
            exit 0
        }
    }

    Write-Output "Compliant - Battery status OK"
    exit 0
}
catch {
    Write-Warning "Error checking battery health: $_"
    exit 1
}
