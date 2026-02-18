<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Show-MessageCenterMessageRemediation
Description: Shows a toast notification with a message from a centrally managed message configuration
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run this script using the logged-on credentials: Yes
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#>

# URL to a publicly accessible JSON file containing the message configuration
$MessageConfigUrl = "https://yourstorageaccount.blob.core.windows.net/messages/current-message.json"

# Local tracking file
$ShownMessagesDir = "$env:LOCALAPPDATA\MessageCenter"
$ShownMessagesFile = "$ShownMessagesDir\shown.txt"

try {
    $Config = Invoke-RestMethod -Uri $MessageConfigUrl -Method Get -ErrorAction Stop

    if (-not $Config.enabled) {
        Write-Output "No active message."
        exit 0
    }

    # Load WinRT assemblies for toast notification
    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

    # Build toast XML
    $ToastXml = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">$($Config.title)</text>
            <text id="2">$($Config.message)</text>
        </binding>
    </visual>
</toast>
"@

    $XmlDoc = New-Object Windows.Data.Xml.Dom.XmlDocument
    $XmlDoc.LoadXml($ToastXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($XmlDoc)
    $Toast.Tag = "MessageCenter"
    $Toast.Group = "MessageCenter"

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Microsoft.Windows.Shell.RunDialog")
    $Notifier.Show($Toast)

    # Track shown message
    if (-not (Test-Path $ShownMessagesDir)) {
        New-Item -Path $ShownMessagesDir -ItemType Directory -Force | Out-Null
    }
    Add-Content -Path $ShownMessagesFile -Value $Config.id

    Write-Output "Message displayed: $($Config.title)"
    exit 0
}
catch {
    Write-Error "Failed to show message: $_"
    exit 1
}
