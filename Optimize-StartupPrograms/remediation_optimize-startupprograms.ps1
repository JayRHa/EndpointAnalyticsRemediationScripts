<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: optimize-startupprograms.ps1
Description: Disables known unnecessary startup programs
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$UnnecessaryStartup = @(
    "iTunes Helper", "Spotify", "Steam", "Discord", "Skype",
    "Adobe Creative Cloud", "CCleaner", "QuickTime",
    "Java Update Scheduler", "Adobe Reader Speed Launcher"
)

try {
    $StartupPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
    )

    $Removed = 0
    foreach ($Path in $StartupPaths) {
        if (Test-Path $Path) {
            $Items = Get-ItemProperty -Path $Path -ErrorAction SilentlyContinue
            foreach ($Entry in $UnnecessaryStartup) {
                if ($Items.PSObject.Properties.Name -contains $Entry) {
                    Remove-ItemProperty -Path $Path -Name $Entry -Force -ErrorAction SilentlyContinue
                    Write-Output "Removed startup entry: $Entry"
                    $Removed++
                }
            }
        }
    }

    Write-Output "Removed $Removed unnecessary startup entries"
    exit 0
}
catch {
    Write-Error "Failed to optimize startup programs: $_"
    exit 1
}
