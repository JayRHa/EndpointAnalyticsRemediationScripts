<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Remediate_DeviceUptime7
Description: Checks the device uptime days. If its 7 days or more it shows a windows notification to the user that he should reboot.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 


function Display-ToastNotification() {
    $Load = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $Load = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
    # Load the notification into the required format
    $ToastXML = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
    $ToastXML.LoadXml($Toast.OuterXml)
        
    # Display the toast notification
    try {
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($App).Show($ToastXml)
    }
    catch { 
        Write-Output -Message 'Something went wrong when displaying the toast notification' -Level Warn
        Write-Output -Message 'Make sure the script is running as the logged on user' -Level Warn     
    }
}
# Setting image variables
$LogoImageUri = "https://raw.githubusercontent.com/insignit/endpointmanagerbranding/master/insignit_512.jpg"
$HeroImageUri = "https://raw.githubusercontent.com/insignit/endpointmanagerbranding/master/InsignIT_hero.png"
$LogoImage = "$env:TEMP\ToastLogoImage.png"
$HeroImage = "$env:TEMP\ToastHeroImage.png"
$Uptime= get-computerinfo | Select-Object OSUptime 

#Fetching images from uri
Invoke-WebRequest -Uri $LogoImageUri -OutFile $LogoImage
Invoke-WebRequest -Uri $HeroImageUri -OutFile $HeroImage

#Defining the Toast notification settings
#ToastNotification Settings
$Scenario = 'reminder' # <!-- Possible values are: reminder | short | long -->
        
# Load Toast Notification text
$AttributionText = "Insign.it"
$HeaderText = "Computer Restart is needed!"
$TitleText = "Your device has not performed a reboot the last $($Uptime.OsUptime.Days) days"
$BodyText1 = "For performance and stability reasons we suggest a reboot at least once a week."
$BodyText2 = "Please save your work and restart your device today. Thank you in advance."


# Check for required entries in registry for when using Powershell as application for the toast
# Register the AppID in the registry for use with the Action Center, if required
$RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings'
$App =  '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'

# Creating registry entries if they don't exists
if (-NOT(Test-Path -Path "$RegPath\$App")) {
    New-Item -Path "$RegPath\$App" -Force
    New-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -Value 1 -PropertyType 'DWORD'
}

# Make sure the app used with the action center is enabled
if ((Get-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -ErrorAction SilentlyContinue).ShowInActionCenter -ne '1') {
    New-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -Value 1 -PropertyType 'DWORD' -Force
}


# Formatting the toast notification XML
[xml]$Toast = @"
<toast scenario="$Scenario">
    <visual>
    <binding template="ToastGeneric">
        <image placement="hero" src="$HeroImage"/>
        <image id="1" placement="appLogoOverride" hint-crop="circle" src="$LogoImage"/>
        <text placement="attribution">$AttributionText</text>
        <text>$HeaderText</text>
        <group>
            <subgroup>
                <text hint-style="title" hint-wrap="true" >$TitleText</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true" >$BodyText1</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true" >$BodyText2</text>
            </subgroup>
        </group>
    </binding>
    </visual>
    <actions>
        <action activationType="system" arguments="dismiss" content="$DismissButtonContent"/>
    </actions>
</toast>
"@

#Send the notification
Display-ToastNotification
Exit 0