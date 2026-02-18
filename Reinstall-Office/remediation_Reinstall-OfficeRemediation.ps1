<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Reinstall-OfficeRemediation
Description: Repairs Microsoft 365 Apps (Office) installation using online repair
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $C2RPath = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
    $OfficeC2RClient = Join-Path $env:ProgramFiles "Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"

    if (Test-Path $OfficeC2RClient) {
        # Trigger online repair
        Start-Process -FilePath $OfficeC2RClient -ArgumentList "/repair", "RepairType=FullRepair", "DisplayLevel=False" -Wait -NoNewWindow -ErrorAction Stop
        Write-Output "Office online repair initiated successfully."
        exit 0
    }
    else {
        Write-Error "OfficeC2RClient.exe not found. Office may need to be reinstalled manually."
        exit 1
    }
}
catch {
    Write-Error "Failed to repair Office: $_"
    exit 1
}
