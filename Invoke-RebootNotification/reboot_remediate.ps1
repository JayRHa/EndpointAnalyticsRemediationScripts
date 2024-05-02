<#
Version: 1.0
Author: Niklas Rast (niklasrast.com)
Script: remediate.ps1
Description: This script shows a toast notification to the user if the device has not been rebooted for 14 days.
Hint: 
Version: 1.0
Run as: User
Context: 64 Bit
#> 

# Toast information
$Title = "Your device has not rebooted since"

$Message = "`nTo ensure the stability and proper functioning of your system, consider rebooting your device very soon."
$Advice = "`nWe recommend you to restart your computer at least once a week"
$Text_AppName = "Microsoft Intune"
$Show_RestartNow_Button = $False
$HeroImage = "C:\Windows\Web\Wallpaper\Windows\img0.jpg"	

Function Set_Action
	{
		param(
		$Action_Name		
		)	
		
		$Main_Reg_Path = "HKCU:\SOFTWARE\Classes\$Action_Name"
		$Command_Path = "$Main_Reg_Path\shell\open\command"
		$CMD_Script = "C:\Windows\Temp\$Action_Name.cmd"
		New-Item $Command_Path -Force
		New-ItemProperty -Path $Main_Reg_Path -Name "URL Protocol" -Value "" -PropertyType String -Force | Out-Null
		Set-ItemProperty -Path $Main_Reg_Path -Name "(Default)" -Value "URL:$Action_Name Protocol" -Force | Out-Null
		Set-ItemProperty -Path $Command_Path -Name "(Default)" -Value $CMD_Script -Force | Out-Null		
	}

$Restart_Script = @'
shutdown /r /f /t 300
'@

$Script_Export_Path = "C:\Windows\Temp"

If($Show_RestartNow_Button -eq $True)
	{
		$Restart_Script | out-file "$Script_Export_Path\RestartScript.cmd" -Force -Encoding ASCII
		Set_Action -Action_Name RestartScript	
	}

Function Register-NotificationApp($AppID,$AppDisplayName) {
    [int]$ShowInSettings = 0

    [int]$IconBackgroundColor = 0
	$IconUri = "C:\Windows\ImmersiveControlPanel\images\logo.png"
	
    $AppRegPath = "HKCU:\Software\Classes\AppUserModelId"
    $RegPath = "$AppRegPath\$AppID"
	
	$Notifications_Reg = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings'
	If(!(Test-Path -Path "$Notifications_Reg\$AppID")) 
		{
			New-Item -Path "$Notifications_Reg\$AppID" -Force
			New-ItemProperty -Path "$Notifications_Reg\$AppID" -Name 'ShowInActionCenter' -Value 1 -PropertyType 'DWORD' -Force
		}

	If((Get-ItemProperty -Path "$Notifications_Reg\$AppID" -Name 'ShowInActionCenter' -ErrorAction SilentlyContinue).ShowInActionCenter -ne '1') 
		{
			New-ItemProperty -Path "$Notifications_Reg\$AppID" -Name 'ShowInActionCenter' -Value 1 -PropertyType 'DWORD' -Force
		}	
		
    try {
        if (-NOT(Test-Path $RegPath)) {
            New-Item -Path $AppRegPath -Name $AppID -Force | Out-Null
        }
        $DisplayName = Get-ItemProperty -Path $RegPath -Name DisplayName -ErrorAction SilentlyContinue | Select -ExpandProperty DisplayName -ErrorAction SilentlyContinue
        if ($DisplayName -ne $AppDisplayName) {
            New-ItemProperty -Path $RegPath -Name DisplayName -Value $AppDisplayName -PropertyType String -Force | Out-Null
        }
        $ShowInSettingsValue = Get-ItemProperty -Path $RegPath -Name ShowInSettings -ErrorAction SilentlyContinue | Select -ExpandProperty ShowInSettings -ErrorAction SilentlyContinue
        if ($ShowInSettingsValue -ne $ShowInSettings) {
            New-ItemProperty -Path $RegPath -Name ShowInSettings -Value $ShowInSettings -PropertyType DWORD -Force | Out-Null
        }
		
		New-ItemProperty -Path $RegPath -Name IconUri -Value $IconUri -PropertyType ExpandString -Force | Out-Null	
		New-ItemProperty -Path $RegPath -Name IconBackgroundColor -Value $IconBackgroundColor -PropertyType ExpandString -Force | Out-Null		
		
    }
    catch {}
}



$Last_reboot = Get-ciminstance Win32_OperatingSystem | Select -Exp LastBootUpTime	
$Check_FastBoot = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -ea silentlycontinue).HiberbootEnabled 
If(($Check_FastBoot -eq $null) -or ($Check_FastBoot -eq 0))
	{
		$Boot_Event = Get-WinEvent -ProviderName 'Microsoft-Windows-Kernel-Boot'| where {$_.ID -eq 27 -and $_.message -like "*0x0*"}
		If($Boot_Event -ne $null)
			{
				$Last_boot = $Boot_Event[0].TimeCreated		
			}
	}
ElseIf($Check_FastBoot -eq 1) 	
	{
		$Boot_Event = Get-WinEvent -ProviderName 'Microsoft-Windows-Kernel-Boot'| where {$_.ID -eq 27 -and $_.message -like "*0x1*"}
		If($Boot_Event -ne $null)
			{
				$Last_boot = $Boot_Event[0].TimeCreated		
			}			
	}		
	
If($Last_boot -eq $null)
	{
		$Uptime = $Uptime = $Last_reboot
	}
Else
	{
		If($Last_reboot -gt $Last_boot)
			{
				$Uptime = $Last_reboot
			}
		Else
			{
				$Uptime = $Last_boot
			}	
	}
	
$Current_Date = get-date
$Diff_boot_time = $Current_Date - $Uptime
$Boot_Uptime_Days = $Diff_boot_time.Days		

$Title = $Title + " $Boot_Uptime_Days day(s)"
$Scenario = 'reminder' 

$Action_Restart = "RestartScript:"
If(($Show_RestartNow_Button -eq $True))
	{
		$Actions = 
@"
  <actions>
        <action activationType="protocol" arguments="$Action_Restart" content="Restart now" />		
        <action activationType="protocol" arguments="Dismiss" content="Dismiss" />
   </actions>	
"@		
	}
Else
	{
		$Actions = 
@"
  <actions>
        <action activationType="protocol" arguments="Dismiss" content="Dismiss" />
   </actions>	
"@		
	}	


[xml]$Toast = @"
<toast scenario="$Scenario">
    <visual>
    <binding template="ToastGeneric">
        <image placement="hero" src="$HeroImage"/>
        <text placement="attribution">$Attribution</text>
        <text>$Title</text>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true" >$Message</text>
            </subgroup>
        </group>
		
		<group>				
			<subgroup>     
				<text hint-style="body" hint-wrap="true" >$Advice</text>								
			</subgroup>				
		</group>				
    </binding>
    </visual>
	$Actions
</toast>
"@	


$AppID = $Text_AppName
$AppDisplayName = $Text_AppName
Register-NotificationApp -AppID $Text_AppName -AppDisplayName $Text_AppName
$Load = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
$Load = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
$ToastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
$ToastXml.LoadXml($Toast.OuterXml)	
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppID).Show($ToastXml)