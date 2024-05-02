<#
Version: 1.0
Author: Niklas Rast (niklasrast.com)
Script: detection.ps1
Description: This script checks if the system has been rebooted within the last 14 days or not.
Hint: 
Version: 1.0
Run as: User
Context: 64 Bit
#> 

# Delay
$Reboot_Delay = 14

	
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
		$Uptime = $Last_reboot
	}
Else
	{
		If($Last_reboot -ge $Last_boot)
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
$Hour = $Diff_boot_time.Hours
$Minutes = $Diff_boot_time.Minutes
$Reboot_Time = "$Boot_Uptime_Days day(s)" + ": $Hour hour(s)" + " : $minutes minute(s)"						
If($Boot_Uptime_Days -ge $Reboot_Delay)
	{
		write-output "Last reboot/shutdown: $Reboot_Time"			
		EXIT 1		
	}
Else
	{
		write-output "Last reboot/shutdown: $Reboot_Time"			
		EXIT 0
	}		
