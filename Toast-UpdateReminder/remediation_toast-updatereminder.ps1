<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: toast-updatereminder.ps1
Description: Shows a toast notification reminding the user to install pending updates
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#>

try {
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $Template = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>Windows Update Required</text>
            <text>Your device has pending updates. Please restart your computer to install important security and feature updates.</text>
        </binding>
    </visual>
    <actions>
        <action content="Remind Later" arguments="dismiss" activationType="system" />
    </actions>
</toast>
"@

    $XmlDoc = [Windows.Data.Xml.Dom.XmlDocument]::New()
    $XmlDoc.LoadXml($Template)

    $AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    $Toast = [Windows.UI.Notifications.ToastNotification]::New($XmlDoc)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)

    Write-Output "Update reminder toast notification displayed"
    exit 0
}
catch {
    Write-Error "Failed to show toast notification: $_"
    exit 1
}
