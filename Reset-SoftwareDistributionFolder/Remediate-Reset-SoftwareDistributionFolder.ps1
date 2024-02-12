<#
Version: 1.0
Author: 
- Jose Schenardie (intune.tech)
Script: Remediate-Reset-SoftwareDistributionFolder
Description: Script to reset the SoftwareDistribution folder by stopping Windows Updates services, renaming the folder to SoftwareDistribution.old and starting the services again.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 
Get-Service -Name wuauserv | Stop-Service
Rename-Item -Path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old
Get-Service -Name wuauserv | Start-Service