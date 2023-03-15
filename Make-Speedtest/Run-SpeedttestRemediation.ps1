<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Make-Speedtest
Description: https://jannikreinhard.com/2022/06/11/use-endpoint-analytics-to-find-slow-internet-breakouts/
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin/USer
Context: 64 Bit
#> 

################################################################################################################
############################################# Variables ########################################################
################################################################################################################
# Speedtest 
$testCount = 3
# Upload a large file to your github repository or download the exaample file from my repo: 'https://github.com/JayRHa/Intune-Scripts/raw/main/Make-Speedtest/testfile.txt'
#Uri from your repo or blob
$testFile = "https://github.com/........"
$fileSize = 5 #File size in Mbit

# Log Analytics Workspcae
$customerId = "" # Add Workspace ID
$sharedKey = "" # Add Primary key
$logType = "Speedtest"
################################################################################################################

Function Measure-NetworkSpeed($f_testFile, $f_fileSize){
    $tempFile  = Join-Path -Path $env:TEMP -ChildPath 'testfile.tmp'
    $webClient = New-Object Net.WebClient
    $time = Measure-Command { $webClient.DownloadFile($f_testFile,$tempFile) } | Select-Object -ExpandProperty TotalSeconds
    $speedMbps = ($f_fileSize / $time) * 8
    return $speedMbps   
}

Function Get-PublicIp{
    return (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
}

Function Build-Signature ($customerId, $sharedKey, $date, $contentLength, $method, $contentType, $resource)
{
    $xHeaders = "x-ms-date:" + $date
    $stringToHash = $method + "`n" + $contentLength + "`n" + $contentType + "`n" + $xHeaders + "`n" + $resource

    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($sharedKey)

    $sha256 = New-Object System.Security.Cryptography.HMACSHA256
    $sha256.Key = $keyBytes
    $calculatedHash = $sha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($calculatedHash)
    $authorization = 'SharedKey {0}:{1}' -f $customerId,$encodedHash
    return $authorization
}

Function Post-LogAnalyticsData($f_customerId, $f_sharedKey, $f_body, $f_logType)
{
    $method = "POST"
    $contentType = "application/json"
    $resource = "/api/logs"
    $rfc1123date = [DateTime]::UtcNow.ToString("r")
    $contentLength = $f_body.Length
    $signature = Build-Signature `
        -customerId $f_customerId `
        -sharedKey $f_sharedKey `
        -date $rfc1123date `
        -contentLength $contentLength `
        -method $method `
        -contentType $contentType `
        -resource $resource
    $uri = "https://" + $f_customerId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"

    $headers = @{
        "Authorization" = $signature;
        "Log-Type" = $f_logType;
        "x-ms-date" = $rfc1123date;
        "time-generated-field" = "";
    }

    $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $f_body -UseBasicParsing
    return $response.StatusCode
}

# Get network speed
$time = 0

for ($i=0; $i -lt $testCount; $i++){
    $time = $time + (Measure-NetworkSpeed -f_testFile $testFile -f_fileSize $fileSize)
}
Write-Host ("{0:N2} Mbit/sec" -f ($time/$testCount))
$ipv4 = (Get-NetIPAddress | Where-Object {$_.AddressState -eq "Preferred" -and $_.ValidLifetime -lt "24:00:00"}).IPAddress

# Send to log analytics
$Properties = [Ordered] @{
    "PublicIp"      = Get-PublicIp
    "LocalIps"      = $ipv4
    "Speed"         = ($time/$testCount)
    "ComputerName"  = $env:computername
}
$speedTest = (New-Object -TypeName "PSObject" -Property $Properties) | ConvertTo-Json

$params = @{
    f_customerId = $customerId
    f_sharedKey  = $sharedKey
    f_body       = ([System.Text.Encoding]::UTF8.GetBytes($speedTest))
    f_logType    = $logType 
}
$logResponse = Post-LogAnalyticsData @params
exit 0
