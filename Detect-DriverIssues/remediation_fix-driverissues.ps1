<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: fix-driverissues.ps1
Description: Attempts to fix driver issues by restarting problem devices
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $ProblemDevices = @()
    $ProblemDevices += Get-PnpDevice -Status Error -ErrorAction SilentlyContinue
    $ProblemDevices += Get-PnpDevice -Status Degraded -ErrorAction SilentlyContinue

    foreach ($Device in $ProblemDevices) {
        try {
            Disable-PnpDevice -InstanceId $Device.InstanceId -Confirm:$false -ErrorAction Stop
            Start-Sleep -Seconds 2
            Enable-PnpDevice -InstanceId $Device.InstanceId -Confirm:$false -ErrorAction Stop
            Write-Output "Restarted device: $($Device.FriendlyName)"
        }
        catch {
            Write-Warning "Could not restart: $($Device.FriendlyName) - $_"
        }
    }

    pnputil /scan-devices 2>&1 | Out-Null
    Write-Output "Driver issue remediation completed"
    exit 0
}
catch {
    Write-Error "Failed to fix driver issues: $_"
    exit 1
}
