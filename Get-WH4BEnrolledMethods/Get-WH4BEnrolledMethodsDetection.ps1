<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Marius Wyss (marius.wyss@microsoft.com)
Script: Get-TemplateDetection
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 

# Detect which WHfB method has been configured

#region SetupLog
$LogDir = $env:temp + "\Logs"
$LogDirSubFolderName = "YOURFOLDERNAME"
$LogFilePath = $env:temp + "\Logs\$LogDirSubFolderName"
$LogFileName = $env:computername + "_WHfB_enrolled_method.log"
$LogFileFullPath = $LogFilePath + "\" + $LogFileName

# check if folder exists or create
If (-Not (Test-Path -Path $LogDir -PathType Container)) {
    New-Item -Path $env:temp -Name "Logs" -ItemType "directory" > $null
} 
If (-Not (Test-Path -Path $LogFilePath -PathType Container)) {
    New-Item -Path $LogDir -Name $LogDirSubFolderName -ItemType "directory" > $null
} 
#endregion SetupLog

Start-Transcript $LogFileFullPath -Append

# Check WHfB reg key 
$LoggedOnUserSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$PinKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{D6886603-9D2F-4EB2-B667-1971041FA96B}\$LoggedOnUserSID"
$BioKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WinBio\AccountInfo\$LoggedOnUserSID"
$BioValueName = "EnrolledFactors"
$PinValueName = "LogonCredsAvailable"

$exitcode = 1
$exitmessage = "Uncaught error"

Try {
    # Check if WH4B is configured
    $PinSetup = Get-ItemProperty -Path $PinKeyPath -Name $PinValueName -ErrorAction Continue
    # Check if Pin is configured
    if ([int]$PinSetup.LogonCredsAvailable -eq 1) {
        # Check if any Biometrics is configured
        if (Test-Path -Path $BioKeyPath) {
            $BioMetrics = Get-ItemProperty -Path $BioKeyPath -Name $BioValueName -ErrorAction Continue
            if ($BioMetrics) {
                $exitcode = 0
                switch ($BioMetrics.EnrolledFactors) {
                    0xa { $exitmessage = "Face and Fingerprint configured" }
                    0x2 { $exitmessage = "Face configured" }
                    0x8 { $exitmessage = "Fingerprint configured" }
                    default { $exitmessage = "Unknown Biometric configured" }
                }
            }
            else {
                $exitmessage = "LogonCredsAvailable Value is not there"
                Write-Warning $exitmessage
                $exitcode = 1
            }
        } 
        # Only PIN is configured
        else {
            $exitmessage = "PIN configured"
            #Write-Host $exitmessage
            $exitcode = 0
        }
    } 
    else {
        $exitmessage = "Windows Hello not configured"
        Write-Warning $exitmessage
        $exitcode = 1
    }
    
}
catch {
    if ($_ -contains "Cannot find path") {
        $exitmessage = "Windows Hello not configured"
        Write-Warning $exitmessage
        $exitcode = 1
    }
    else {
        $exitmessage = "Something went wrong:" + $_
        Write-Error $exitmessage
        $exitcode = 1
    }
}
Stop-Transcript
Write-Host $exitmessage
Exit $exitcode