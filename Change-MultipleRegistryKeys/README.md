<!-- jr-brand:start -->
<p align="center">
  <a href="https://jannikreinhard.com/">
    <img src="https://raw.githubusercontent.com/JayRHa/.github/main/assets/readme/brand-header.png" alt="Jannik Reinhard — I help enterprises ship secure AI agents" width="100%">
  </a>
</p>
<p align="center">
  <a href="https://jannikreinhard.com/">Website</a> ·
  <a href="https://www.linkedin.com/in/jannik-r/">LinkedIn</a> ·
  <a href="https://x.com/jannik_reinhard">X</a> ·
  <a href="https://www.youtube.com/@jannikreinhard">YouTube</a>
</p>
<!-- jr-brand:end -->

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

<!-- jr-brand-footer:start -->
---

[Articles and guides](https://jannikreinhard.com/) · [Repository index](https://github.com/JayRHa/.github/blob/main/REPOSITORIES.md)
<!-- jr-brand-footer:end -->
