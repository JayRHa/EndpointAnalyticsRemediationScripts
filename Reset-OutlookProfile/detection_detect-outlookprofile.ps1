<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-outlookprofile.ps1
Description: Detects Outlook profile issues (oversized OST files)
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxOSTSizeGB = 25

try {
    $UserProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue
    $NonCompliant = $false

    foreach ($Profile in $UserProfiles) {
        $OutlookPath = Join-Path $Profile.FullName "AppData\Local\Microsoft\Outlook"
        if (Test-Path $OutlookPath) {
            $OSTFiles = Get-ChildItem -Path $OutlookPath -Filter "*.ost" -ErrorAction SilentlyContinue
            foreach ($OST in $OSTFiles) {
                $SizeGB = [math]::Round($OST.Length / 1GB, 2)
                if ($SizeGB -gt $MaxOSTSizeGB) {
                    Write-Warning "Not Compliant - OST for $($Profile.Name) is $SizeGB GB"
                    $NonCompliant = $true
                }
            }
        }
    }

    if ($NonCompliant) { exit 1 }

    Write-Output "Compliant - No oversized Outlook data files found"
    exit 0
}
catch {
    Write-Warning "Error checking Outlook profile: $_"
    exit 1
}
