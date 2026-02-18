<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: free-diskspace.ps1
Description: Frees disk space by cleaning common locations
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    # Windows Temp
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Cleared Windows Temp"

    # Windows Update Cache
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Write-Output "Cleared Windows Update cache"

    # User Temp Folders
    Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $UserTemp = Join-Path $_.FullName "AppData\Local\Temp"
        if (Test-Path $UserTemp) {
            Remove-Item -Path "$UserTemp\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Output "Cleared user temp folders"

    # Recycle Bin
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Output "Cleared Recycle Bin"

    # Run Disk Cleanup
    $CleanupKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
    Get-ChildItem $CleanupKey -ErrorAction SilentlyContinue | ForEach-Object {
        New-ItemProperty -Path $_.PSPath -Name "StateFlags0100" -Value 2 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:100" -Wait -NoNewWindow -ErrorAction SilentlyContinue

    Write-Output "Disk space cleanup completed"
    exit 0
}
catch {
    Write-Error "Failed to free disk space: $_"
    exit 1
}
