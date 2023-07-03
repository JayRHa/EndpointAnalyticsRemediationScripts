<#
Version: 1.0
Author: 
Tom Coleman
Script: Detect SMB Signing
Description: Background https://learn.microsoft.com/en-GB/troubleshoot/windows-server/networking/overview-server-message-block-signing
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$Path = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManWorkstation\Parameters'
$Name = 'RequireSecuritySignature'
$Type = "DWORD"
$Value = 1

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value 