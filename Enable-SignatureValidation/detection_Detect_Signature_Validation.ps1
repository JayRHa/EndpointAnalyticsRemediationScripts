<#
Version: 1.0
Author: 
- Tom Coleman
Script: Enable-SignatureValidation
Description: Written to resolve this https://msrc.microsoft.com/update-guide/vulnerability/CVE-2013-3900
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$Path = 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Wintrust\Config', 'Registry::HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config'

foreach ($i in $Path){
    if ((Test-Path $i)) {
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
}

