# Registry

Validate and set Registry settings according to your needs.

## Usage/Examples

In the **Change-MultipleRegistryKeysDetection.ps1** and **Change-MultipleRegistryKeysRemediaton.ps1** add to or change the ```$RegistrySettingsToValidate``` array with registry settings, represented as a ```pscustomobject```, you want to validate respectively set/remediate.

e.g:

```powershell
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
```

Allowed Values for the ```Type``` property are:

- ```REG_SZ```
- ```REG_DWORD```
- ```REG_BINARY```
- ```REG_QWORD```
- ```REG_MULTI_SZ```
- ```REG_EXPAND_SZ```
