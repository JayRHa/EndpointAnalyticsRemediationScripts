<#

Author       : Sven Wick
Script       : Detect-Browser-Passwords.ps1
Description  : Script detects if common Browsers have passwords stored locally
Requirements : sqlite3.exe installed

               You can use
               https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/tree/main/Add-Winget-App
               with winget appid "SQLite.SQLite" for example to install sqlite3.exe

Run this script using the logged-on credentials: Yes
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes

#>

# Path to the sqlite3 executable
$sqlitePath = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\SQLite.SQLite_Microsoft.Winget.Source_8wekyb3d8bbwe\sqlite3.exe"

$found_some_passwords = $false
$found_sqlite_binary  = $false
$message              = @()
$profilePaths         = @()
$filePaths            = @()

# Check for sqlite3 binary
if (Test-Path $sqlitePath) {
    $found_sqlite_binary = $true
}

$chromeBasedAppDataPaths = @(
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\",
    "$env:APPDATA\Opera Software\Opera Stable\"
)

$firefoxBasedAppDataPaths = @(
    "$env:APPDATA\Mozilla\Firefox\Profiles"
)

#
# Find profile folders of chrome-based Browsers
#

foreach ( $browserAppDataPath in $chromeBasedAppDataPaths ) {

    # Get all folders that match "Default" or "Profile *"
    $profileFolders = Get-ChildItem -Path $browserAppDataPath -Directory | Where-Object { $_.Name -eq "Default" -or $_.Name -like "Profile *" }

    foreach ($folder in $profileFolders) {
        $profilePaths = $profilePaths + $($folder.FullName)

    }

}

#
# Find profile folder of firefox-based browsers
#

foreach ( $browserAppDataPath in $firefoxBasedAppDataPaths ) {

    $profileFolders = Get-ChildItem -Path $browserAppDataPath

    foreach ($folder in $profileFolders) {
        $profilePaths = $profilePaths + $($folder.FullName)

    }

}

#
# Find all "logins.json" and "Login Data" files in all profile folders
#

foreach ( $profilePath in $profilePaths ) {

    $loginFiles = Get-ChildItem -Path $profilePath -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -in @("logins.json", "Login Data") }

    foreach ($file in $loginFiles) {
          $filePaths = $filePaths + $($file.FullName)
    }

}

#
# Iterate over each file path and check if the file exists and count the number of passwords
#

foreach ($filePath in $filePaths) {

    if (Test-Path $filePath) {

        $filename = (Get-Item -Path $filePath).Name

        #
        # Firefox-based Browsers
        #

        if ($filename -eq "logins.json") {

            # Read the JSON file
            $jsonContent = Get-Content -Path $filePath -Raw | ConvertFrom-Json

            # Check if the list named "logins" exists in the JSON data
            if ($jsonContent.logins) {

                # Count the number of elements in the named list
                $countLogins = $jsonContent.logins.Count

                if ($countLogins -gt 0) {
                  $found_some_passwords = $true
                  $message = $message + "${countLogins} password(s) detected : ${filePath}"
                }
            }
        }

        #
        # Chrome-based Browsers
        #

        # Skip testing when no sqlite tools available

        if (-not ($found_sqlite_binary)) {
            continue
        }

        if ($filename -eq "Login Data") {

            # Generate a temporary file path
            $tempFilePath = [System.IO.Path]::GetTempFileName()

            # Copy the database file to the temporary file path
            # because the SQLite file is usually locked by the Browser

            Copy-Item -Path $filePath -Destination $tempFilePath

            # SQL query to execute
            $sqlQuery = "SELECT COUNT(*) FROM logins WHERE blacklisted_by_user != 1;"

            # Run sqlite3.exe with the copied database file and the query, and capture the output
            $countLogins = & $sqlitePath $tempFilePath $sqlQuery

            # Output the results
            if ($countLogins -gt 0) {
                $found_some_passwords = $true
                $message = $message + "${countLogins} password(s) detected : ${filePath}"
	        }

            # Remove the temporary file
            Remove-Item -Path $tempFilePath
        }
    }
}

if (-not ($found_sqlite_binary)) {
    Write-Output "Not Compliant - ${sqlitePath} not found"
    Exit 1
}

if ($found_some_passwords) {

    $output  = $message -join " | "
    Write-Output $output
    Exit 1

} else {

    Write-Output "Compliant"
    Exit 0

}
