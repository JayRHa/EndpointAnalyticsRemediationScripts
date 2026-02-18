<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Update-MicrosoftTeamsRemediation
Description: Updates Microsoft Teams using winget
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\winget.exe") |
        Sort-Object LastWriteTime | Select-Object -Last 1 -ExpandProperty FullName

    if (-not $Winget) {
        $Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\AppInstallerCLI.exe") |
            Sort-Object LastWriteTime | Select-Object -Last 1 -ExpandProperty FullName
    }

    if ($Winget) {
        $Result = &$Winget upgrade --id "Microsoft.Teams" --silent --force --accept-package-agreements --accept-source-agreements 2>&1
        Write-Output "Teams update result: $Result"
        exit 0
    }
    else {
        Write-Error "Winget not found. Cannot update Teams."
        exit 1
    }
}
catch {
    Write-Error "Failed to update Microsoft Teams: $_"
    exit 1
}
