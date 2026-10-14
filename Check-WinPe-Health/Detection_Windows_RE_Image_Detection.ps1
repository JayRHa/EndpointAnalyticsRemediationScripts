# Windows RE Image Detection
# Intune Remediation Detection Script

$ReAgentXmlPath = "$env:windir\System32\Recovery\ReAgent.xml"

if (-not (Test-Path $ReAgentXmlPath)) {
    Write-Output "Windows Recovery Environment configuration not found."
    exit 1
}

try {
    $ReAgent = [xml](Get-Content $ReAgentXmlPath -Raw -ErrorAction Stop)
}
catch {
    Write-Output "Unable to read Windows Recovery Environment configuration."
    exit 1
}

$WinRELocation = $ReAgent.WindowsRE.WinreLocation

if (-not $WinRELocation) {
    Write-Output "Windows Recovery Environment location is not configured."
    exit 1
}

try {
    $Offset = [uint64]$WinRELocation.offset

    $Partition = Get-Partition | Where-Object {
        $_.Offset -eq $Offset
    } | Select-Object -First 1

    if (-not $Partition) {
        Write-Output "Windows Recovery Environment partition not found."
        exit 1
    }

    $Volume = Get-Volume -Partition $Partition -ErrorAction Stop

    if (-not $Volume.Path) {
        Write-Output "Windows Recovery Environment volume path not found."
        exit 1
    }

    $WinREImage = Join-Path $Volume.Path "Recovery\WindowsRE\Winre.wim"

    if ([System.IO.File]::Exists($WinREImage)) {
        Write-Output "Windows Recovery Environment image exists."
        exit 0
    }
    else {
        Write-Output "Windows Recovery Environment image does not exist."
        exit 1
    }
}
catch {
    Write-Output "Unable to verify Windows Recovery Environment image."
    exit 1
}