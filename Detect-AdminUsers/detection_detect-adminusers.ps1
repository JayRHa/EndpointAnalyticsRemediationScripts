<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-adminusers.ps1
Description: Detects unauthorized local administrator accounts
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

# Add known/allowed admin accounts here
$AllowedAdmins = @("Administrator", "intune_admin")

try {
    $AdminGroup = Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop
    $UnauthorizedAdmins = @()

    foreach ($Member in $AdminGroup) {
        $AccountName = $Member.Name.Split("\")[-1]
        if ($AccountName -notin $AllowedAdmins -and $Member.ObjectClass -eq "User") {
            $UnauthorizedAdmins += $Member.Name
        }
    }

    if ($UnauthorizedAdmins.Count -gt 0) {
        Write-Warning "Not Compliant - Found $($UnauthorizedAdmins.Count) unauthorized admin accounts"
        $UnauthorizedAdmins | ForEach-Object { Write-Warning "  $_" }
        exit 1
    }

    Write-Output "Compliant - No unauthorized admin accounts found"
    exit 0
}
catch {
    Write-Warning "Error checking admin users: $_"
    exit 1
}
