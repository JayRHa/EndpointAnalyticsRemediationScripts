<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Run-DiskDiagnosticDetection
Description: Detects disk health issues using S.M.A.R.T. data and disk status
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $DiskIssues = @()

    # Check physical disk health via Storage CIM
    $Disks = Get-PhysicalDisk -ErrorAction SilentlyContinue
    foreach ($Disk in $Disks) {
        if ($Disk.HealthStatus -ne "Healthy") {
            $DiskIssues += "Disk '$($Disk.FriendlyName)' status: $($Disk.HealthStatus)"
        }
        if ($Disk.OperationalStatus -ne "OK") {
            $DiskIssues += "Disk '$($Disk.FriendlyName)' operational status: $($Disk.OperationalStatus)"
        }
    }

    # Check disk space on system drive
    $SystemDrive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'" -ErrorAction SilentlyContinue
    if ($SystemDrive) {
        $FreeSpacePercent = [math]::Round(($SystemDrive.FreeSpace / $SystemDrive.Size) * 100, 2)
        if ($FreeSpacePercent -lt 10) {
            $DiskIssues += "System drive free space is low: $FreeSpacePercent%"
        }
    }

    if ($DiskIssues.Count -gt 0) {
        Write-Output "Disk issues found: $($DiskIssues -join ' | ')"
        exit 1
    }
    else {
        Write-Output "All disks are healthy."
        exit 0
    }
}
catch {
    Write-Error "Failed to run disk diagnostic: $_"
    exit 1
}
