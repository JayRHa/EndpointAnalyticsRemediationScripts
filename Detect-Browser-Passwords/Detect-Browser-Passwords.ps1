<#

Author       : Sven Wick
Script       : Detect-Browser-Passwords.ps1
Description  : Script detects if common Browsers have have passwords stored locally
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

# Check for sqlite3 binary
if (Test-Path $sqlitePath) {
    $found_sqlite_binary = $true
}

# Define an array of file paths
$filePaths = @(
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Login Data",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Login Data",
    "$env:APPDATA\Opera Software\Opera Stable\Login Data"
)

# Get the path to the Firefox profiles
$firefoxProfilesPath = "$env:APPDATA\Mozilla\Firefox\Profiles"

# Get all Firefox Profiles

if (Test-Path $firefoxProfilesPath) {
  $firefoxProfiles = Get-ChildItem -Path $firefoxProfilesPath

  # Define the postfix
  $postfix = "\logins.json"

  # Create a list of paths with the postfix added
  $firefoxProfilesPaths = $firefoxProfiles | ForEach-Object { $_.FullName + $postfix }

  # Add the Firefox profile paths to the existing array
  $filePaths += $firefoxProfilesPaths
}

# Iterate over each file path and check if the file exists
# and count the number of passwords

foreach ($filePath in $filePaths) {

    if (Test-Path $filePath) {

        $filename = (Get-Item -Path $filePath).Name

        #
        # Firefox
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
