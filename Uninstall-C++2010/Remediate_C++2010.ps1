<#
Version: 1.0
Author: 
Tom Coleman
Script: Uninstall C++ 2010 Redistributable
Description: https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$Name = 'Microsoft.VCRedist.2010'

try{
    Get-AppxPackage -Name $Name | Remove-AppxPackage -ErrorAction stop
    Write-Host "Microsoft Visual C++ 2010 successfully removed"
}catch{
    Write-Error "Error removing Microsoft Visual C++ 2010"
}