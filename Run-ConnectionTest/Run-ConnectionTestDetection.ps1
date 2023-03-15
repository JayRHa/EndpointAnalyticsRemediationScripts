<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Run-ConnectionTest
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin/User
Context: 64 Bit
#> 

function Get-ConnectionTest {
    param(
		[Parameter(Mandatory)]
		$connections,
		
		[Parameter(Mandatory)]
		[int]$port
	)

    $success = $true
    $connections | ForEach-Object {
        $result = (Test-NetConnection -Port $port -ComputerName $_.uri)    
        if(-not($result.TcpTestSucceeded)) {
            $success = $false
        }
    }
    return $success
}


###########################################################################
################################# START ###################################
###########################################################################
$connections443 = @(
    [pscustomobject]@{uri='www.msftconnecttest.com';Area='Connection test'},

    [pscustomobject]@{uri='login.microsoftonline.com';Area='Microsoft authentication'},
    [pscustomobject]@{uri='aadcdn.msauth.net';Area='Microsoft authentication'},

    [pscustomobject]@{uri='enterpriseregistration.windows.net';Area='Intune'},
    [pscustomobject]@{uri='enterpriseenrollment-s.manage.microsoft.com';Area='Intune'},
    [pscustomobject]@{uri='enterpriseEnrollment.manage.microsoft.com';Area='Intune'},
    [pscustomobject]@{uri='enrollment.manage.microsoft.com';Area='Intune'},
    [pscustomobject]@{uri='portal.manage.microsoft.com';Area='Intune'},
    [pscustomobject]@{uri='config.office.com';Area='Intune'},
    [pscustomobject]@{uri='graph.windows.net';Area='Intune'},
    [pscustomobject]@{uri='m.manage.microsoft.com';Area='Intune'},
    [pscustomobject]@{uri='fef.msuc03.manage.microsoft.com';Area='Intune'},
    [pscustomobject]@{uri='mam.manage.microsoft.com';Area='Intune'},
    [pscustomobject]@{uri='manage.microsoft.com';Area='Intune'},

    [pscustomobject]@{uri='ztd.dds.microsoft.com';Area='Autopilot Service'},
    [pscustomobject]@{uri='cs.dds.microsoft.com';Area='Autopilot Service'},
    [pscustomobject]@{uri='login.live.com';Area='Autopilot Service'},

    [pscustomobject]@{uri='activation.sls.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='licensing.mp.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='validation-v2.sls.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='validation.sls.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='purchase.mp.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='purchase.md.mp.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='licensing.md.mp.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='go.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='displaycatalog.md.mp.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='displaycatalog.mp.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='activation-v2.sls.microsoft.com';Area='License activation'},
    [pscustomobject]@{uri='activation.sls.microsoft.com';Area='License activation'},

    [pscustomobject]@{uri='emdl.ws.microsoft.com';Area='Windows Update'},
    [pscustomobject]@{uri='dl.delivery.mp.microsoft.com';Area='Windows Update'},
    [pscustomobject]@{uri='update.microsoft.com';Area='Windows Update'},
    [pscustomobject]@{uri='fe2cr.update.microsoft.com';Area='Windows Update'},

    [pscustomobject]@{uri='autologon.microsoftazuread-sso.com';Area='Single sign-on'},

    [pscustomobject]@{uri='powershellgallery.com';Area='Powershell gallery'},

    [pscustomobject]@{uri='ekop.intel.com';Area='TPM check'},
    [pscustomobject]@{uri='ekcert.spserv.microsoft.com';Area='TPM check'},
    [pscustomobject]@{uri='ftpm.amd.com';Area='TPM check'},

    [pscustomobject]@{uri='naprodimedatapri.azureedge.net';Area='Powershell and Win32'},
    [pscustomobject]@{uri='naprodimedatasec.azureedge.net';Area='Powershell and Win32'},
    [pscustomobject]@{uri='naprodimedatahotfix.azureedge.net';Area='Powershell and Win32'},
    [pscustomobject]@{uri='euprodimedatapri.azureedge.net';Area='Powershell and Win32'},
    [pscustomobject]@{uri='euprodimedatasec.azureedge.net';Area='Powershell and Win32'},
    [pscustomobject]@{uri='euprodimedatahotfix.azureedge.net';Area='Powershell and Win32'},
    [pscustomobject]@{uri='approdimedatapri.azureedge.net';Area='Powershell and Win32'},
    [pscustomobject]@{uri='approdimedatasec.azureedge.net';Area='Powershell and Win32'},
    [pscustomobject]@{uri='approdimedatahotfix.azureedge.net';Area='Powershell and Win32'},

    [pscustomobject]@{uri='v10c.events.data.microsoft.com';Area='Update Compliance'},
    [pscustomobject]@{uri='v10.vortex-win.data.microsoft.com';Area='Update Compliance'},
    [pscustomobject]@{uri='settings-win.data.microsoft.com';Area='Update Compliance'},
    [pscustomobject]@{uri='adl.windows.com';Area='Update Compliance'},
    [pscustomobject]@{uri='watson.telemetry.microsoft.com';Area='Update Compliance'},
    [pscustomobject]@{uri='oca.telemetry.microsoft.com';Area='Update Compliance'}       
)

$connections80 = @(
    [pscustomobject]@{uri='emdl.ws.microsoft.com';Area='Windows Update'},
    [pscustomobject]@{uri='dl.delivery.mp.microsoft.com';Area='Windows Update'}
)

$success = $false
if(-not (Get-ConnectionTest -connections $connections443 -port 443)){$success = $false}
if(-not (Get-ConnectionTest -connections $connections80 -port 80)){$success = $false}

if($success){
    Write-Host "Connection Test successfull"
    return 0
}else{
    Write-Host "Connection Test not successfull"
    return 1
}