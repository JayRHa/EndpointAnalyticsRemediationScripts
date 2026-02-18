<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: clear-tempfiles.ps1
Description: Clears temporary files, logs, crash dumps, thumbnails and prefetch
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $TempPaths = @(
        @{ Path = "$env:SystemRoot\Temp"; Desc = "Windows Temp" },
        @{ Path = "$env:SystemRoot\Logs\CBS"; Desc = "CBS Logs" },
        @{ Path = "$env:SystemRoot\Logs\DISM"; Desc = "DISM Logs" },
        @{ Path = "$env:SystemRoot\Minidump"; Desc = "Crash Dumps" },
        @{ Path = "$env:SystemRoot\Prefetch"; Desc = "Prefetch" }
    )

    foreach ($Item in $TempPaths) {
        if (Test-Path $Item.Path) {
            Remove-Item -Path "$($Item.Path)\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Output "Cleared $($Item.Desc)"
        }
    }

    # Clear user temp folders
    $UserProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue
    foreach ($Profile in $UserProfiles) {
        $UserTemp = Join-Path $Profile.FullName "AppData\Local\Temp"
        if (Test-Path $UserTemp) {
            Remove-Item -Path "$UserTemp\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Output "Cleared temp for user: $($Profile.Name)"
        }
        $ThumbCache = Join-Path $Profile.FullName "AppData\Local\Microsoft\Windows\Explorer"
        if (Test-Path $ThumbCache) {
            Get-ChildItem -Path $ThumbCache -Filter "thumbcache_*.db" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
        }
    }

    Write-Output "Temporary files cleared successfully"
    exit 0
}
catch {
    Write-Error "Failed to clear temp files: $_"
    exit 1
}
