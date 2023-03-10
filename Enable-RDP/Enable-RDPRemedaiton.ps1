<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Enable-RDP
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

function IsMember
{
  param(
        [String]$GroupSID = "",
        [String]$UserSID = ""     
        )
    $memebers = Get-LocalGroupMember -SID $GroupSID
    $isMember = $false
    foreach ($memeber in $memebers)
    {
        if($memeber.sid -eq $UserSID) {$isMember = $true}
    }
    return $isMember
}

# Enable RDP
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections' -Value 0
# Enable Networklevel authentication
(Get-WmiObject -class Win32_TSGeneralSetting -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)


if(IsMember -GroupSID S-1-5-32-555 -UserSID S-1-1-0){
}else{
    Add-LocalGroupMember -SID S-1-5-32-555 -Member "S-1-1-0"
}

