<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: remove-adminusers.ps1
Description: Removes unauthorized users from the local Administrators group
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$AllowedAdmins = @("Administrator", "intune_admin")

try {
    $AdminGroup = Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop

    foreach ($Member in $AdminGroup) {
        $AccountName = $Member.Name.Split("\")[-1]
        if ($AccountName -notin $AllowedAdmins -and $Member.ObjectClass -eq "User") {
            Remove-LocalGroupMember -Group "Administrators" -Member $Member.Name -ErrorAction Stop
            Write-Output "Removed from Administrators: $($Member.Name)"
        }
    }

    Write-Output "Unauthorized admin accounts have been removed"
    exit 0
}
catch {
    Write-Error "Failed to remove admin users: $_"
    exit 1
}
