<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Remove-ReinstallMSIRemediation
Description: Removes and optionally reinstalls a specified MSI application
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

# Configure the application
$AppName = "YourApplicationName"  # Display name of the MSI app (supports wildcards)
$ReinstallMSIPath = ""             # Path to MSI for reinstall (leave empty to only remove)
$ReinstallArgs = "/qn /norestart"  # MSI install arguments

try {
    # Find the installed application
    $Uninstall64 = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like "*$AppName*" }
    $Uninstall32 = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like "*$AppName*" }

    $InstalledApps = @($Uninstall64) + @($Uninstall32) | Where-Object { $_ -ne $null }

    # Uninstall each found instance
    foreach ($App in $InstalledApps) {
        $UninstallString = $App.UninstallString
        if ($UninstallString -match "msiexec") {
            $ProductCode = $App.PSChildName
            Start-Process "msiexec.exe" -ArgumentList "/x $ProductCode /qn /norestart" -Wait -NoNewWindow -ErrorAction Stop
            Write-Output "Uninstalled: $($App.DisplayName)"
        }
        elseif ($UninstallString) {
            Start-Process "cmd.exe" -ArgumentList "/c `"$UninstallString`" /S /quiet" -Wait -NoNewWindow -ErrorAction SilentlyContinue
            Write-Output "Uninstalled: $($App.DisplayName)"
        }
    }

    # Reinstall if path is provided
    if ($ReinstallMSIPath -and (Test-Path $ReinstallMSIPath)) {
        Start-Process "msiexec.exe" -ArgumentList "/i `"$ReinstallMSIPath`" $ReinstallArgs" -Wait -NoNewWindow -ErrorAction Stop
        Write-Output "Reinstalled from: $ReinstallMSIPath"
    }

    exit 0
}
catch {
    Write-Error "Failed to remove/reinstall application: $_"
    exit 1
}
