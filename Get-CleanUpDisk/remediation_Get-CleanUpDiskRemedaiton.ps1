<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Get-CleanUpDisk
Description:
Possible Values:
'Active Setup Temp Folders', 'BranchCache', 'Content Indexer Cleaner', 'Device Driver Packages', 'Downloaded Program Files', 'GameNewsFiles', 'GameStatisticsFiles', 'GameUpdateFiles',
'Internet Cache Files', 'Memory Dump Files', 'Offline Pages Files', 'Old ChkDsk Files', 'Previous Installations', 'Recycle Bin', 'Service Pack Cleanup', 'Setup Log Files', 'System error memory dump files',
'System error minidump files', 'Temporary Files', 'Temporary Setup Files', 'Temporary Sync Files', 'Thumbnail Cache', 'Update Cleanup', 'Upgrade Discarded Files', 'User file versions', 'Windows Defender',
'Windows Error Reporting Archive Files', 'Windows Error Reporting Queue Files', 'Windows Error Reporting System Archive Files', 'Windows Error Reporting System Queue Files', 'Windows ESD installation files',
'Windows Upgrade Log Files'
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$cleanupTypeSelection = 'Temporary Sync Files', 'Downloaded Program Files', 'Memory Dump Files', 'Recycle Bin'

foreach ($keyName in $cleanupTypeSelection) {
    $newItemParams = @{
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$keyName"
        Name         = 'StateFlags0001'
        Value        = 2
        PropertyType = 'DWord'
        ErrorAction  = 'SilentlyContinue'
    }
    New-ItemProperty @newItemParams | Out-Null
}

Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1' -NoNewWindow -Wait
