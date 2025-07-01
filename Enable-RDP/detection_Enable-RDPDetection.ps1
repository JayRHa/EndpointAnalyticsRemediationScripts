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

# Always trigger
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


if((Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections').fDenyTSConnections){
    Write-Host "RDP is disabled"
    return 1
}else{
    Write-Host "RDP is enabled"
}

if(IsMember -GroupSID S-1-5-32-555 -UserSID S-1-1-0){
    Write-Host "User is member of the RDP group"
    exit 0
}
Write-Host "User is not member of the RDP group"
exit 1