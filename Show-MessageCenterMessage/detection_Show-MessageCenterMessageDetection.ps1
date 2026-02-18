<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Show-MessageCenterMessageDetection
Description: Detects if there is a message to display to the user (via a centrally managed message file)
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run this script using the logged-on credentials: Yes
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#>

# URL to a publicly accessible JSON file containing the message configuration
# Example JSON: { "enabled": true, "title": "IT Announcement", "message": "Maintenance window tonight 10pm-2am", "id": "msg-001" }
$MessageConfigUrl = "https://yourstorageaccount.blob.core.windows.net/messages/current-message.json"

# Local tracking file
$ShownMessagesFile = "$env:LOCALAPPDATA\MessageCenter\shown.txt"

try {
    $Config = Invoke-RestMethod -Uri $MessageConfigUrl -Method Get -ErrorAction Stop

    if (-not $Config.enabled) {
        Write-Output "No active message."
        exit 0
    }

    # Check if this message was already shown
    if (Test-Path $ShownMessagesFile) {
        $ShownIds = Get-Content $ShownMessagesFile -ErrorAction SilentlyContinue
        if ($Config.id -in $ShownIds) {
            Write-Output "Message '$($Config.id)' already shown."
            exit 0
        }
    }

    Write-Output "New message to display: $($Config.title)"
    exit 1
}
catch {
    Write-Output "Could not check for messages: $_"
    exit 0
}
