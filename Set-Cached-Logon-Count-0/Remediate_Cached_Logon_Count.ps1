<#
Version: 1.0
Author: 
Tom Coleman
Script: Detect Cached Logon Count
Description: Windows NT may use a cache to store the last interactive logon (i.e. console logon), to provide a safe logon for the host in the event that the Domain Controller goes down. This feature is currently activated on this host.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$Path = 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Nt\CurrentVersion\Winlogon'
$Name = 'CachedLogonsCount'
$Value = 0

Set-ItemProperty -Path $Path -Name $Name -Value $Value 