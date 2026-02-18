<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Clear-BrowserCacheRemediation
Description: Clears Chrome and Edge browser cache
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run this script using the logged-on credentials: Yes
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#>

$CachePaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\GPUCache",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\GPUCache"
)

$ClearedPaths = @()

foreach ($path in $CachePaths) {
    if (Test-Path $path) {
        try {
            Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            $ClearedPaths += $path
        }
        catch {
            Write-Warning "Could not clear cache at: $path - $_"
        }
    }
}

if ($ClearedPaths.Count -gt 0) {
    Write-Output "Successfully cleared cache from: $($ClearedPaths -join ', ')"
    exit 0
}
else {
    Write-Output "No cache paths found to clear."
    exit 0
}
