if ( Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" ) {
    if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Name "BlockAADWorkplaceJoin" -ea 0).BlockAADWorkplaceJoin -eq 1)
    { exit 0 }
    else 
    { exit 1 }
}
else
{ exit 1 }
