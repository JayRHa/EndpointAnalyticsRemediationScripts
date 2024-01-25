<#
Version: 1.0
Author: 
- Jasper van der Straten
Script: Detect_DellSupportassist.ps1
Description: Detects DellSupportAssist installation
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

Try {
    $DellSA = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | 
              Where-Object {$_.DisplayName -eq 'Dell SupportAssist'} | 
              Select-Object -Property DisplayName, UninstallString

    if ($DellSA) {
        $installed = $true
        $uninstallString = $DellSA.UninstallString
    } else {
        $installed = $false
    }

    if ($installed) {
        Write-Output "Not Compliant"
        Write-Output "Uninstall String: $uninstallString"
        Exit 1
    } else {
        Write-Output "Compliant"
        Exit 0
    }
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}
