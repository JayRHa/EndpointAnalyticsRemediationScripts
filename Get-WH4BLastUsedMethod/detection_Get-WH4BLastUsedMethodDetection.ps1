<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Marius Wyss (marius.wyss@microsoft.com)
Script: Get-WH4BLastUsedMethodDetection
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 

# Detect which Windows Hello for Business authentication method has been last used

#region SetupLog
$LogDir = $env:temp + "\Logs"
$LogDirSubFolderName = "YOURFOLDERNAME"
$LogFilePath = $env:temp + "\Logs\$LogDirSubFolderName"
$LogFileName = $env:computername + "_WHfB_lastused_method.log"
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

# Check Last Login Path reg key 
$LastLogin = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI"
$LastLoginvalue = "LastLoggedOnProvider"


$exitcode = 1
$exitmessage = ""

Try {
        # Check Last Login
        if (Test-Path -Path $LastLogin) {
            $LoginMetrics = Get-ItemProperty -Path $Lastlogin -Name $LastLoginvalue -ErrorAction Continue
            if ($LoginMetrics) {
                $exitcode = 0
                switch ($LoginMetrics.LastLoggedOnProvider) {
                    '{D6886603-9D2F-4EB2-B667-1971041FA96B}' { $exitmessage = "Pin authentication" }
                    '{BEC09223-B018-416D-A0AC-523971B639F5}' { $exitmessage = "Fingerprint authentication" }
                    '{8AF662BF-65A0-4D0A-A540-A338A999D36F}' { $exitmessage = "Facial authentication" }
                    '{60B78E88-EAD8-445C-9CFD-0B87F74EA6CD}' { $exitmessage = "Password authentication" }
                    '{F8A1793B-7873-4046-B2A7-1F318747F427}' { $exitmessage = "FIDO authentication" }
                    default { $exitmessage = "Unknown device authentication" }
                }
            } else {
                $exitmessage = "LastLoggedOnProvider Value is not there"
                Write-Warning $exitmessage
                $exitcode = 1
       }
      }
    
} catch {
    if ($_ -contains "Cannot find path") {
        $exitmessage = "Authentication method cannot be checked"
        Write-Warning $exitmessage
        $exitcode = 1
    } else {
        $exitmessage = "Something went wrong:" + $_
        Write-Error $exitmessage
        $exitcode = 1
    }
}

Stop-Transcript
Write-Host $exitmessage
Exit $exitcode