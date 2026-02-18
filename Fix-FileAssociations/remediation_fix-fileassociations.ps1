<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: fix-fileassociations.ps1
Description: Repairs broken file associations by resetting to Windows defaults
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $DefaultAssociations = @{
        ".txt"  = "txtfile"
        ".pdf"  = "MSEdgePDF"
        ".jpg"  = "PhotoViewer.FileAssoc.Jpeg"
        ".jpeg" = "PhotoViewer.FileAssoc.Jpeg"
        ".png"  = "PhotoViewer.FileAssoc.Png"
        ".gif"  = "PhotoViewer.FileAssoc.Gif"
        ".mp4"  = "WMP11.AssocFile.MP4"
        ".zip"  = "CompressedFolder"
        ".xml"  = "xmlfile"
        ".log"  = "txtfile"
    }

    foreach ($Ext in $DefaultAssociations.Keys) {
        $RegPath = "HKLM:\SOFTWARE\Classes\$Ext"
        if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
        Set-ItemProperty -Path $RegPath -Name "(Default)" -Value $DefaultAssociations[$Ext] -Force
        Write-Output "Reset association: $Ext -> $($DefaultAssociations[$Ext])"
    }

    Write-Output "File associations have been repaired"
    exit 0
}
catch {
    Write-Error "Failed to fix file associations: $_"
    exit 1
}
