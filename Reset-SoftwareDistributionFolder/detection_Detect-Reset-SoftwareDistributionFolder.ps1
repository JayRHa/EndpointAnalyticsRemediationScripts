<#
Version: 1.0
Author: 
- Jose Schenardie (intune.tech)
Script: Detect-Reset-SoftwareDistributionFolder
Description: Script to reset the SoftwareDistribution folder by stopping Windows Updates services, renaming the folder to SoftwareDistribution.old and starting the services again.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 
if (Test-Path C:\Windows\SoftwareDistribution.old)
    {exit 0}
else 
    {exit 1}