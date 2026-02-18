<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: fix-officeactivation.ps1
Description: Repairs Office activation by clearing license cache
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $OfficeProcesses = @("WINWORD", "EXCEL", "POWERPNT", "OUTLOOK", "MSACCESS", "ONENOTE")
    foreach ($Proc in $OfficeProcesses) {
        Get-Process -Name $Proc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 3

    $LicensePaths = @(
        "$env:LOCALAPPDATA\Microsoft\Office\Licenses",
        "$env:LOCALAPPDATA\Microsoft\Office\16.0\Licensing"
    )
    foreach ($Path in $LicensePaths) {
        if (Test-Path $Path) {
            Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Output "Cleared license cache: $Path"
        }
    }

    $ClickToRunPath = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
    if (Test-Path $ClickToRunPath) {
        Start-Process -FilePath $ClickToRunPath -ArgumentList "/repair" -Wait -NoNewWindow -ErrorAction SilentlyContinue
        Write-Output "Office repair triggered"
    }

    Write-Output "Office activation repair completed"
    exit 0
}
catch {
    Write-Error "Failed to fix Office activation: $_"
    exit 1
}
