<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Run-DiskDiagnosticRemediation
Description: Runs disk cleanup and optimization to remediate disk issues
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    # Set cleanup flags in registry for automated cleanmgr
    $CleanupFlags = @(
        "Active Setup Temp Folders",
        "Temporary Files",
        "Recycle Bin",
        "Temporary Setup Files",
        "Windows Error Reporting Files",
        "Thumbnail Cache",
        "Delivery Optimization Files"
    )

    $VolumeCachesPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
    foreach ($Flag in $CleanupFlags) {
        $FlagPath = Join-Path $VolumeCachesPath $Flag
        if (Test-Path $FlagPath) {
            Set-ItemProperty -Path $FlagPath -Name "StateFlags0100" -Value 2 -Type DWord -ErrorAction SilentlyContinue
        }
    }

    # Run disk cleanup silently
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:100" -Wait -NoNewWindow -ErrorAction SilentlyContinue

    # Optimize system drive
    $SystemDrive = $env:SystemDrive.TrimEnd(':')
    Optimize-Volume -DriveLetter $SystemDrive -ErrorAction SilentlyContinue

    Write-Output "Disk cleanup and optimization completed."
    exit 0
}
catch {
    Write-Error "Failed to run disk remediation: $_"
    exit 1
}
