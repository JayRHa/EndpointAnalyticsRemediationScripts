<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Marius Wyss (marius.wyss@microsoft.com)
Script: Change-MultipleRegistryKeysRemediaton.ps1
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User/Admin
Context: 64 Bit
#> 

# Description: This script creates the registry keys defined below.
# Output: (single line)
#  If ok, a prefix string (33) + each the key name
#   e.g: All OK | Registry values created: YourFirstKeyName, YourSecondKeyName
#  If not ok, a prefix string (52) + each created key (without the not created keys)
#   e.g: Something went wrong :-( | Registry values created: YourFirstKeyName, YourSecondKeyName

#region Define registry keys to create here
# Action: "Update" to create/update the key, "Delete" to remove the key
$RegistrySettingsToValidate = @(
    [pscustomobject]@{
        Hive   = 'HKLM:\'
        Key    = 'SOFTWARE\Contoso\Product'
        Name   = 'ImportantKey'
        Type   = 'REG_DWORD'
        Value  = 1
        Action = 'Update'
    },
    [pscustomobject]@{
        Hive   = 'HKLM:\'
        Key    = 'SOFTWARE\Contoso\Product'
        Name   = 'AnotherKey'
        Type   = 'REG_SZ'
        Value  = "SomeValue"
        Action = 'Update'
    },
    [pscustomobject]@{
        Hive   = 'HKLM:\'
        Key    = 'SOFTWARE\Contoso\Product'
        Name   = 'OldKey'
        Type   = 'REG_DWORD'
        Value  = 0
        Action = 'Delete'
    }
)
#endregion

#region helper functions, enums and maps
$RegTypeMap = @{
    REG_DWORD = [Microsoft.Win32.RegistryValueKind]::DWord
    REG_SZ = [Microsoft.Win32.RegistryValueKind]::String
    REG_QWORD = [Microsoft.Win32.RegistryValueKind]::QWord
    REG_BINARY = [Microsoft.Win32.RegistryValueKind]::Binary
    REG_MULTI_SZ = [Microsoft.Win32.RegistryValueKind]::MultiString
    REG_EXPAND_SZ = [Microsoft.Win32.RegistryValueKind]::ExpandString
}
#endregion

#region Create/Delete registry keys
$Output = "Something went wrong :-("
$CreatedNames = @()
$DeletedNames = @()
$ExitCode = 1
Foreach ($reg in $RegistrySettingsToValidate) {

    $DesiredPath          = "$($reg.Hive)$($reg.Key)"
    $DesiredName          = $reg.Name
    $DesiredType          = $RegTypeMap[$reg.Type]
    $DesiredValue         = $reg.Value
    $Action               = if ($reg.PSObject.Properties['Action']) { $reg.Action } else { 'Update' }

    if ($Action -eq 'Delete') {
        if ((Test-Path -Path $DesiredPath) -and (Get-ItemProperty -Path $DesiredPath -Name $DesiredName -ErrorAction SilentlyContinue)) {
            Remove-ItemProperty -Path $DesiredPath -Name $DesiredName -Force -ErrorAction SilentlyContinue
            $DeletedNames += $DesiredName
        } else {
            $DeletedNames += $DesiredName
        }
    } else {
        If (-not (Test-Path -Path $DesiredPath)) {
            New-Item -Path $DesiredPath -Force | Out-Null
        }
        New-ItemProperty -Path $DesiredPath -Name $DesiredName -PropertyType $DesiredType -Value $DesiredValue -Force -ErrorAction SilentlyContinue | Out-Null
        $CreatedNames += $DesiredName
    }
}
#endregion

#region Check if registry keys are set correctly
$TotalProcessed = $CreatedNames.count + $DeletedNames.count
If ($TotalProcessed -eq $RegistrySettingsToValidate.count) {
    $OutputParts = @()
    if ($CreatedNames.count -gt 0) { $OutputParts += "Created: $($CreatedNames -join ', ')" }
    if ($DeletedNames.count -gt 0) { $OutputParts += "Deleted: $($DeletedNames -join ', ')" }
    $Output = "All OK | $($OutputParts -join ' | ')"
    $ExitCode = 0
} else {
    $Output = "Something went wrong :-( | Created: $($CreatedNames -join ', ') | Deleted: $($DeletedNames -join ', ')"
    $ExitCode = 1
}
#endregion

Write-Output $Output
Exit $ExitCode