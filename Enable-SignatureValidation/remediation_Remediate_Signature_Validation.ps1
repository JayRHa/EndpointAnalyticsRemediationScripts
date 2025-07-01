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
$Name = 'EnableCertPaddingCheck'
$value = '1'

Foreach ($i In $Path)
{
    if (!(Test-Path $i)) {

New-Item -Path $i -Name 'Config' -force | Out-null
    new-itemproperty -Path $i -name $name -value $value -force | out-null

}
}

shutdown.exe /r /t 2700 /c "I am afraid there is a critical sytem patch requiring a reboot in 45 minutes"