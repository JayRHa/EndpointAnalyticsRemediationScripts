<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Reinstall-OfficeDetection
Description: Detects if Microsoft 365 Apps (Office) installation is broken or missing
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $OfficeInstalled = $false

    # Check for Click-to-Run Office
    $C2RPath = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
    if (Test-Path $C2RPath) {
        $C2RVersion = (Get-ItemProperty -Path $C2RPath -ErrorAction SilentlyContinue).VersionToReport
        if ($C2RVersion) {
            $OfficeInstalled = $true
        }
    }

    # Check if Office apps are accessible
    if ($OfficeInstalled) {
        $OfficeApps = @("WINWORD.EXE", "EXCEL.EXE", "POWERPNT.EXE", "OUTLOOK.EXE")
        $MissingApps = @()

        $OfficePath = (Get-ItemProperty -Path $C2RPath -ErrorAction SilentlyContinue).InstallationPath
        foreach ($App in $OfficeApps) {
            $AppPath = Join-Path $OfficePath "root\Office16\$App"
            if (-not (Test-Path $AppPath)) {
                $MissingApps += $App
            }
        }

        if ($MissingApps.Count -gt 0) {
            Write-Output "Office installed but missing apps: $($MissingApps -join ', ')"
            exit 1
        }
        else {
            Write-Output "Office is installed and all apps are present. Version: $C2RVersion"
            exit 0
        }
    }
    else {
        Write-Output "Microsoft 365 Apps not found."
        exit 1
    }
}
catch {
    Write-Error "Failed to detect Office installation: $_"
    exit 1
}
