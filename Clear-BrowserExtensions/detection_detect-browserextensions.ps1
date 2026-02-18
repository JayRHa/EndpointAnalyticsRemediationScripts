<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-browserextensions.ps1
Description: Detects unapproved browser extensions in Chrome and Edge
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

# Add approved extension IDs here
$ApprovedExtensions = @()

try {
    $UserProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue
    $UnapprovedFound = $false

    foreach ($Profile in $UserProfiles) {
        $ChromeExtPath = Join-Path $Profile.FullName "AppData\Local\Google\Chrome\User Data\Default\Extensions"
        if (Test-Path $ChromeExtPath) {
            $Exts = (Get-ChildItem -Path $ChromeExtPath -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -notin $ApprovedExtensions -and $_.Name -ne "Temp" }).Count
            if ($Exts -gt 0) {
                Write-Warning "Not Compliant - $Exts unapproved Chrome extensions for $($Profile.Name)"
                $UnapprovedFound = $true
            }
        }

        $EdgeExtPath = Join-Path $Profile.FullName "AppData\Local\Microsoft\Edge\User Data\Default\Extensions"
        if (Test-Path $EdgeExtPath) {
            $Exts = (Get-ChildItem -Path $EdgeExtPath -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -notin $ApprovedExtensions -and $_.Name -ne "Temp" }).Count
            if ($Exts -gt 0) {
                Write-Warning "Not Compliant - $Exts unapproved Edge extensions for $($Profile.Name)"
                $UnapprovedFound = $true
            }
        }
    }

    if ($UnapprovedFound) { exit 1 }

    Write-Output "Compliant - No unapproved browser extensions found"
    exit 0
}
catch {
    Write-Warning "Error checking browser extensions: $_"
    exit 1
}
