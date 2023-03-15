<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detection_BitlockerRecoveryKey
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

Try {
$Result = (Get-BitLockerVolume -MountPoint C).KeyProtector
$Recoverykey = $result.recoverypassword

If ($recoverykey -ne $null)
{
    Write-Output "Bitlocker recovery key available $Recoverykey "
    exit 0
}
Else
{
    Write-Output "No bitlocker recovery key available starting remediation"
    exit 1
}
}
catch
{
Write-Warning "Value Missing"
exit 1
}
