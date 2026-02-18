<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: set-defaultbrowser.ps1
Description: Sets Microsoft Edge as the default browser via policy
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $XmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".htm" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
  <Association Identifier=".html" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
  <Association Identifier="http" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
  <Association Identifier="https" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
</DefaultAssociations>
"@

    $XmlPath = "$env:SystemRoot\System32\DefaultAssociations.xml"
    $XmlContent | Out-File -FilePath $XmlPath -Encoding UTF8 -Force

    $PolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    if (-not (Test-Path $PolicyPath)) { New-Item -Path $PolicyPath -Force | Out-Null }
    New-ItemProperty -Path $PolicyPath -Name "DefaultAssociationsConfiguration" -Value $XmlPath -PropertyType String -Force | Out-Null

    Write-Output "Default browser has been set to Microsoft Edge"
    exit 0
}
catch {
    Write-Error "Failed to set default browser: $_"
    exit 1
}
