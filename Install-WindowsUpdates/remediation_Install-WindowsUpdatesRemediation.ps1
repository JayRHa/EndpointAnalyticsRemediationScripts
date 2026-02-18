<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Install-WindowsUpdatesRemediation
Description: Installs all pending Windows updates
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $UpdateSession = New-Object -ComObject Microsoft.Update.Session
    $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
    $SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software'")

    if ($SearchResult.Updates.Count -eq 0) {
        Write-Output "No pending updates to install."
        exit 0
    }

    $UpdatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
    foreach ($Update in $SearchResult.Updates) {
        if ($Update.EulaAccepted -eq $false) {
            $Update.AcceptEula()
        }
        $UpdatesToDownload.Add($Update) | Out-Null
    }

    # Download updates
    $Downloader = $UpdateSession.CreateUpdateDownloader()
    $Downloader.Updates = $UpdatesToDownload
    $DownloadResult = $Downloader.Download()

    # Install updates
    $Installer = $UpdateSession.CreateUpdateInstaller()
    $Installer.Updates = $UpdatesToDownload
    $InstallResult = $Installer.Install()

    Write-Output "Updates installed. Result code: $($InstallResult.ResultCode). Reboot required: $($InstallResult.RebootRequired)"
    exit 0
}
catch {
    Write-Error "Failed to install Windows updates: $_"
    exit 1
}
