<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-fileassociations.ps1
Description: Detects broken file associations for common file types
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$CommonExtensions = @(".txt", ".pdf", ".docx", ".xlsx", ".pptx", ".jpg", ".png", ".mp4", ".zip")

try {
    $Broken = @()
    foreach ($Ext in $CommonExtensions) {
        $AssocResult = cmd /c "assoc $Ext" 2>$null
        if (-not $AssocResult -or $AssocResult -match "not found") {
            $Broken += $Ext
        }
    }

    if ($Broken.Count -gt 0) {
        Write-Warning "Not Compliant - Broken file associations: $($Broken -join ', ')"
        exit 1
    }

    Write-Output "Compliant - All common file associations are valid"
    exit 0
}
catch {
    Write-Warning "Error checking file associations: $_"
    exit 1
}
