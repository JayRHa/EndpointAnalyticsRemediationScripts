<#
Version: 1.1
Author: 
- Jasper van der Straten
Script: Remediate_DellSupportassist.ps1
Description: Uninstalls DellSupportAssist installation
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

$DellSA = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | 
              Where-Object {$_.DisplayName -eq 'Dell SupportAssist'} | 
              Select-Object -Property DisplayName, UninstallString

Write-Host $DellSA.UninstallString

try {
    if ($DellSA.UninstallString -match 'msiexec.exe') {
        # Extract the GUID from the UninstallString
        $null = $DellSA.UninstallString -match '{[A-F0-9-]+}'
        $guid = $matches[0]

        Write-Host "Removing Dell SupportAssist using msiexec..."
        Start-Process msiexec.exe -ArgumentList "/x $($guid) /qn" -Wait
    } elseif ($DellSA.UninstallString -match 'SupportAssistUninstaller.exe') {
        Write-Host "Removing Dell SupportAssist using SupportAssistUninstaller.exe..."
        Start-Process "$($DellSA.UninstallString)" -ArgumentList "/arp /S" -Wait
	} else {
        Write-Host "Unsupported uninstall method found."
        Exit 1
    }

    Write-Host "Dell SupportAssist successfully removed"
    Exit 0
} catch {
    Write-Error "Error removing Dell SupportAssist"
    Exit 1
}
