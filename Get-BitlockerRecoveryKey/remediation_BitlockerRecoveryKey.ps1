<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: remediation_BitlockerRecoveryKey
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

Try 
{
	$BLinfo = Get-Bitlockervolume
	if($BLinfo.EncryptionPercentage -eq '100')
	{
			$Result = (Get-BitLockerVolume -MountPoint C).KeyProtector
			$Recoverykey = $result.recoverypassword	
			Write-Output "Bitlocker recovery key $recoverykey"
		Exit 0
	}else{
		Write-Output "This is only for reporting, no key aviable"
		Exit 1
	}
}
catch
{
Write-Warning "Value Missing"
	Exit 1
}

