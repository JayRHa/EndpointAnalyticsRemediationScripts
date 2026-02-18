<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Update-MicrosoftTeamsDetection
Description: Detects if Microsoft Teams is outdated and needs updating
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    # Check for new Teams (MSIX)
    $NewTeams = Get-AppxPackage -AllUsers -Name "MSTeams" -ErrorAction SilentlyContinue

    if ($NewTeams) {
        Write-Output "New Teams installed. Version: $($NewTeams.Version)"
        # New Teams updates itself, check if it's running
        exit 0
    }

    # Check for classic Teams Machine-Wide Installer
    $TeamsMWI = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like "*Teams Machine-Wide Installer*" }

    if (-not $TeamsMWI) {
        $TeamsMWI = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "*Teams Machine-Wide Installer*" }
    }

    if (-not $TeamsMWI -and -not $NewTeams) {
        Write-Output "Microsoft Teams is not installed."
        exit 1
    }

    # Check if winget has an update available for Teams
    $Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\winget.exe") |
        Sort-Object LastWriteTime | Select-Object -Last 1 -ExpandProperty FullName

    if ($Winget) {
        $UpdateCheck = &$Winget upgrade --id "Microsoft.Teams" --accept-source-agreements 2>&1
        if ($UpdateCheck -match "available") {
            Write-Output "Teams update available."
            exit 1
        }
    }

    Write-Output "Microsoft Teams is up to date."
    exit 0
}
catch {
    Write-Error "Failed to check Teams status: $_"
    exit 1
}
