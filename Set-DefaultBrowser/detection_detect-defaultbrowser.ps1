<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-defaultbrowser.ps1
Description: Detects if the default browser is set to the corporate standard (Edge)
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$TargetBrowser = "MSEdgeHTM"

try {
    $UserPath = "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice"
    $UserDefault = Get-ItemProperty -Path $UserPath -Name "ProgId" -ErrorAction SilentlyContinue

    if ($UserDefault -and $UserDefault.ProgId -eq $TargetBrowser) {
        Write-Output "Compliant - Default browser is set to $TargetBrowser"
        exit 0
    }

    Write-Warning "Not Compliant - Default browser is $($UserDefault.ProgId) (expected: $TargetBrowser)"
    exit 1
}
catch {
    Write-Warning "Error checking default browser: $_"
    exit 1
}
