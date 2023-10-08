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
$RegistrySettingsToValidate = @(
    [pscustomobject]@{
        Hive  = 'HKLM:\'
        Key   = 'SOFTWARE\Contoso\Product'
        Name  = 'ImportantKey'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKLM:\'
        Key   = 'SOFTWARE\Contoso\Product'
        Name  = 'AnotherKey'
        Type  = 'REG_SZ'
        Value = "SomeValue"
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
    [RegKeyError]$CurrentKeyError = 15

    $DesiredPath          = "$($reg.Hive)$($reg.Key)"
    $DesiredName          = $reg.Name
    $DesiredType          = $RegTypeMap[$reg.Type]
    $DesiredValue         = $reg.Value

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
                    # Write-Host "[$DesiredPath | $DesiredName | $RetTypeRegistry | $DesiredValue] exists and is correct"
                } 
            }
        }
    }
    $KeyErrors += $CurrentKeyError
    $Output += " | $DesiredName ErrorCode = $CurrentKeyError"
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