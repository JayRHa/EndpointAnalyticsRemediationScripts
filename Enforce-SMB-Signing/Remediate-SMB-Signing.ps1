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

$Path = 'HKLM\System\CurrentControlSet\Services\LanManWorkstation\Parameters'
$Name = 'RequireSecuritySignature'
$Type = "DWORD"
$Value = 1

New-ItemProperty -LiteralPath $Path -Name $Name -Value $Value -PropertyType $Type