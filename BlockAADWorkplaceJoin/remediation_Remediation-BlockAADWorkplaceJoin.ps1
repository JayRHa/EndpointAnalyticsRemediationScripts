#Function Region
Function New-Reg ($registryPath, $name, $Value, $type) {
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType $type -Force | Out-Null
    }
    else { New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType $type -Force | Out-Null }
}
#EndRegion

#Variables Region
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin"
$name = "BlockAADWorkplaceJoin"
$value = "1"
$type = "DWord"
#EndRegion

#Code Region
New-Reg -registryPath $registryPath -name $name -value $value -type $type
#EndRegion
