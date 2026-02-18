<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: remove-bloatware.ps1
Description: Removes OEM bloatware and unnecessary pre-installed apps
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$Bloatware = @(
    "AD2F1837.HPJumpStarts", "AD2F1837.HPPCHardwareDiagnosticsWindows",
    "AD2F1837.HPPowerManager", "AD2F1837.HPPrivacySettings",
    "AD2F1837.HPSupportAssistant", "AD2F1837.myHP",
    "DellInc.DellSupportAssistforPCs", "DellInc.DellDigitalDelivery",
    "E046963F.LenovoCompanion", "E046963F.LenovoSettings",
    "king.com.CandyCrushSaga", "king.com.CandyCrushSodaSaga",
    "king.com.BubbleWitch3Saga", "SpotifyAB.SpotifyMusic",
    "Facebook.Facebook", "9E2F88E3.Twitter",
    "A278AB0D.DisneyMagicKingdoms", "A278AB0D.MarchofEmpires",
    "D5EA27B7.Duolingo-LearnLanguagesforFree",
    "Microsoft.BingNews", "Microsoft.BingWeather",
    "Microsoft.GamingApp", "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People", "Microsoft.SkypeApp",
    "Microsoft.MixedReality.Portal", "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp", "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay", "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.ZuneMusic", "Microsoft.ZuneVideo",
    "Microsoft.YourPhone", "Clipchamp.Clipchamp"
)

try {
    $Removed = 0
    foreach ($App in $Bloatware) {
        $Package = Get-AppxPackage -AllUsers -Name $App -ErrorAction SilentlyContinue
        if ($Package) {
            $Package | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
                Where-Object { $_.PackageName -like "*$App*" } |
                Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            Write-Output "Removed: $App"
            $Removed++
        }
    }

    Write-Output "Removed $Removed bloatware applications"
    exit 0
}
catch {
    Write-Error "Failed to remove bloatware: $_"
    exit 1
}
