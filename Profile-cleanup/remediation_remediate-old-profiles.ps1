<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: remediate-old-profiles.ps1
Description: Removes old user profiles over 30 days old via DelProf1 or DelProf2
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

function Save-VerifiedDownload {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Uri,

        [Parameter(Mandatory = $true)]
        [string]$OutFile,

        [Parameter(Mandatory = $true)]
        [string]$ExpectedSha256
    )

    Invoke-WebRequest -Uri $Uri -OutFile $OutFile -UseBasicParsing -ErrorAction Stop
    $actualHash = (Get-FileHash -Path $OutFile -Algorithm SHA256).Hash.ToLowerInvariant()

    if ($actualHash -ne $ExpectedSha256.ToLowerInvariant()) {
        Remove-Item -Path $OutFile -Force -ErrorAction SilentlyContinue
        throw "Hash validation failed for $OutFile. Expected $ExpectedSha256, got $actualHash."
    }
}

$days = 30
$profiles = (get-CimInstance win32_userprofile | Where-Object {$_.LastUseTime -lt $(Get-Date).Date.AddDays(-$days)})
$profilecount = $profiles.Count
if ($profilecount -gt 0) {
write-host "There are profiles to remove" -ForegroundColor Red
##Temp location to use
$tempdir = $env:TEMP
##Comment out whichever version you don't want to use

##Download DelProf1
Save-VerifiedDownload -Uri "https://github.com/andrew-s-taylor/public/raw/main/delprof/delprof.exe" -OutFile "$tempdir\delprof.exe" -ExpectedSha256 "1da35d3bc379f57de9384fef2ce8f9a29cea9f5e8a6550a5023f29f39bf327ad"
##Run DelProf1
Start-Process -FilePath "$tempdir\delprof.exe" -ArgumentList /Q /D:$days
Remove-Item "$tempdir\delprof.exe"

##Download DelProf2
Save-VerifiedDownload -Uri "https://github.com/andrew-s-taylor/public/raw/main/delprof/DelProf2.exe" -OutFile "$tempdir\delprof2.exe" -ExpectedSha256 "b456e05c6825dea9f854e3ae37deb36e7f5f2d847fc2c7f053327559a9414ed6"
##Run DelProf2
Start-Process -FilePath "$tempdir\delprof2.exe" -ArgumentList /q /d:$days
remove-item "$tempdir\delprof2.exe"

}
else {
write-host "No old profiles to remove" -ForegroundColor Green
}
