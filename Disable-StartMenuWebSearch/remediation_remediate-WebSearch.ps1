<#
Version: 1.0
Author: 
Tom Coleman
Script: Stop Web Search
Description: Disabling web search on the start menu makes it so much faster and effective. No lag at all anymore! 
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
$Name = "BingSearchEnabled"
$Type = "DWORD"
$Value = 0

New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force -ea SilentlyContinue;