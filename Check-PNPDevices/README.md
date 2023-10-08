# Devices

**Check-PNPDevicesDetectionDetection.ps1** checks devices, if they are working as expected, if not it will return the devices and exit non-zero.
**Check-PNPDevicesRemediation.ps1** will remove the devices and trigger a re-detect.

## Usage/Examples

### Filter

If you want to run the script only against a subset of devices, you can use the following variables to filter the devices.

- ```$ClassFilterInclude```
- ```$ClassFilterExclude```
- ```$DeviceIDFilterInclude```
- ```$DeviceIDFilterExclude```

#### Order of precedence

> [Devices with Error] -> ClassFilterExclude -> ClassFilterInclude -> DeviceIDFilterExclude -> DeviceIDFilterInclude -> [Devices to detect / remediate]

- You can use the wildcard character `*` to match any device in the ```$ClassFilterInclude``` variable and ```$DeviceIDFilterInclude``` variable.
- Exclude has precedence over include.
- Class filter is applied first, then DeviceID filter.

#### Examples

```powershell
# Filter out Net and USB devices, in this subset only include Display, Ports and Sound devices. Then exclude the PCI\VEN_8086&DEV_46A8&SUBSYS_00741414&REV_0C\3&11583659&0&10 and ACPI\PNP0C02\5 devices.

$ClassFilterExclude = "Net", "USB"
$ClassFilterInclude = "Display", "Ports", "Sound"
$DeviceIDFilterExclude = "PCI\VEN_8086&DEV_46A8&SUBSYS_00741414&REV_0C\3&11583659&0&10", "ACPI\PNP0C02\5"
$DeviceIDFilterInclude = "*"
```

```powershell
# A more reasonable example.
# Don't care about USB and Mouse devices. Include all other devices. Exclude the Cisco AnyConnect VPN device and PS/2 Keyboard.

$ClassFilterExclude = "USB", "Mouse"
$ClassFilterInclude = "*"
$DeviceIDFilterExclude = "ROOT\NET\0000", "ACPI\HPQ8002\4&1003D552&0"
$DeviceIDFilterInclude = "*"
```
