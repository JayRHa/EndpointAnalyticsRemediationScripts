<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Marius Wyss (marius.wyss@microsoft.com)
Script: Change-MultipleRegistryKeysDetection.ps1
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User/Admin
Context: 64 Bit
#> 

# Description: This script checks if the registry keys defined are set correctly.
# Output: (single line)
#  For each key: {Name of the key} + {Error Values} (max 37 characters)
#   e.g: YourFirstKeyName ErrorCode = Path, Name, Type, Value | YourSecondKeyName ErrorCode = Path, Name

#region Define registry keys to validate here
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
    REG_DWORD     = [Microsoft.Win32.RegistryValueKind]::DWord
    REG_SZ        = [Microsoft.Win32.RegistryValueKind]::String
    REG_QWORD     = [Microsoft.Win32.RegistryValueKind]::QWord
    REG_BINARY    = [Microsoft.Win32.RegistryValueKind]::Binary
    REG_MULTI_SZ  = [Microsoft.Win32.RegistryValueKind]::MultiString
    REG_EXPAND_SZ = [Microsoft.Win32.RegistryValueKind]::ExpandString
}
[Flags()] enum RegKeyError {
    None  = 0
    Path  = 1
    Name  = 2
    Type  = 4
    Value = 8
}
#endregion

#region Check if registry keys are set correctly
$KeyErrors = @()
$Output = ""
Foreach ($reg in $RegistrySettingsToValidate) {
    $DesiredPath          = "$($reg.Hive)$($reg.Key)"
    $DesiredName          = $reg.Name
    $DesiredType          = $RegTypeMap[$reg.Type]
    $DesiredValue         = $reg.Value
    $Action               = if ($reg.PSObject.Properties['Action']) { $reg.Action } else { 'Update' }

    if ($Action -eq 'Delete') {
        # For Delete: key should NOT exist. If it exists, that's an error.
        if ((Test-Path -Path $DesiredPath) -and (Get-ItemProperty -Path $DesiredPath -Name $DesiredName -ErrorAction SilentlyContinue)) {
            [RegKeyError]$CurrentKeyError = [RegKeyError]::Name
            $Output += " | $DesiredName Action=Delete ErrorCode = $CurrentKeyError (exists, should be deleted)"
        } else {
            [RegKeyError]$CurrentKeyError = [RegKeyError]::None
            $Output += " | $DesiredName Action=Delete ErrorCode = $CurrentKeyError (already absent)"
        }
    } else {
        [RegKeyError]$CurrentKeyError = 15

        # Check if the registry key path exists
        If (Test-Path -Path $DesiredPath) {
            $CurrentKeyError -= [RegKeyError]::Path

            # Check if the registry value exists
            If (Get-ItemProperty -Path $DesiredPath -Name $DesiredName -ErrorAction SilentlyContinue) {
                $CurrentKeyError -= [RegKeyError]::Name

                # Check if the registry value type is correct
                If ($(Get-Item -Path $DesiredPath).GetValueKind($DesiredName) -eq $DesiredType) {
                    $CurrentKeyError -= [RegKeyError]::Type

                    # Check if the registry value is correct
                    If ($((Get-ItemProperty -Path $DesiredPath -Name $DesiredName).$DesiredName) -eq $DesiredValue) {
                        $CurrentKeyError -= [RegKeyError]::Value
                    }
                }
            }
        }
        $Output += " | $DesiredName ErrorCode = $CurrentKeyError"
    }
    $KeyErrors += $CurrentKeyError
}
#endregion

#region Check if all registry keys are correct
if (($KeyErrors.value__ | Measure-Object -Sum).Sum -eq 0) {
    $ExitCode = 0
}
else {
    $ExitCode = 1
}
#endregion

Write-Output $Output.TrimStart(" |")
Exit $ExitCode