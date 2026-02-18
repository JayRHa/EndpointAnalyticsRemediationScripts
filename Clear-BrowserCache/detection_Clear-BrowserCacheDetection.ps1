<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Clear-BrowserCacheDetection
Description: Detects if Chrome or Edge browser cache exceeds a specified size threshold
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run this script using the logged-on credentials: Yes
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#>

# Cache size threshold in MB
$ThresholdMB = 500

$TotalCacheSizeMB = 0

# Chrome cache paths
$ChromeCachePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
$ChromeCodeCachePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache"

# Edge cache paths
$EdgeCachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
$EdgeCodeCachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache"

$CachePaths = @($ChromeCachePath, $ChromeCodeCachePath, $EdgeCachePath, $EdgeCodeCachePath)

foreach ($path in $CachePaths) {
    if (Test-Path $path) {
        $size = (Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $TotalCacheSizeMB += [math]::Round($size / 1MB, 2)
    }
}

if ($TotalCacheSizeMB -gt $ThresholdMB) {
    Write-Output "Browser cache size is $TotalCacheSizeMB MB (threshold: $ThresholdMB MB)"
    exit 1
}
else {
    Write-Output "Browser cache size is $TotalCacheSizeMB MB (threshold: $ThresholdMB MB) - Compliant"
    exit 0
}
