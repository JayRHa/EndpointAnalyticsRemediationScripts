<#
Version: 1.0
Author: 
Tom Coleman
Script: Detect C++ 2010 Redistributable
Description: https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#>

$Name = 'Microsoft.VCRedist.2010'

if ($null -eq (Get-AppxPackage -Name $Name)) {
	Write-Host "Microsoft Visual C++ 2010 is not installed"
	exit 0
} Else {
	Write-Host "Microsoft Visual C++ 2010 is installed"
	Exit 1
}