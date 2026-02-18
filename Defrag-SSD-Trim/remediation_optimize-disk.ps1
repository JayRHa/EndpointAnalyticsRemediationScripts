<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: optimize-disk.ps1
Description: Runs TRIM on SSDs or defrag on HDDs and enables scheduled optimization
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq "Fixed" }

    foreach ($Vol in $Volumes) {
        $PhysicalDisk = Get-PhysicalDisk | Where-Object { $_.DeviceId -eq (Get-Partition -DriveLetter $Vol.DriveLetter -ErrorAction SilentlyContinue).DiskNumber } -ErrorAction SilentlyContinue

        if ($PhysicalDisk.MediaType -eq "SSD") {
            Optimize-Volume -DriveLetter $Vol.DriveLetter -ReTrim -ErrorAction Stop
            Write-Output "TRIM completed on SSD drive $($Vol.DriveLetter):"
        }
        else {
            Optimize-Volume -DriveLetter $Vol.DriveLetter -Defrag -ErrorAction Stop
            Write-Output "Defrag completed on drive $($Vol.DriveLetter):"
        }
    }

    $OptTask = Get-ScheduledTask -TaskName "ScheduledDefrag" -ErrorAction SilentlyContinue
    if ($OptTask -and $OptTask.State -eq "Disabled") {
        Enable-ScheduledTask -TaskName "ScheduledDefrag" -ErrorAction SilentlyContinue
        Write-Output "Scheduled disk optimization has been enabled"
    }

    Write-Output "Disk optimization completed successfully"
    exit 0
}
catch {
    Write-Error "Failed to optimize disk: $_"
    exit 1
}
