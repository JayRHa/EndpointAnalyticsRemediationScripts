<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Copy-FilesToBlobStorageDetection
Description: Detects if specified files exist locally and need to be uploaded to Azure Blob Storage
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

# Configure the source files/folders to check
$SourcePaths = @(
    "$env:ProgramData\YourApp\Logs",
    "$env:ProgramData\YourApp\Config"
)

# Marker file to track last upload
$MarkerFile = "$env:ProgramData\BlobStorageUpload\lastupload.txt"

$FilesFound = @()

foreach ($Path in $SourcePaths) {
    if (Test-Path $Path) {
        $Files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue
        if ($Files) {
            # Check if files are newer than last upload
            if (Test-Path $MarkerFile) {
                $LastUpload = Get-Item $MarkerFile | Select-Object -ExpandProperty LastWriteTime
                $NewFiles = $Files | Where-Object { $_.LastWriteTime -gt $LastUpload }
                if ($NewFiles) {
                    $FilesFound += $NewFiles
                }
            }
            else {
                $FilesFound += $Files
            }
        }
    }
}

if ($FilesFound.Count -gt 0) {
    Write-Output "Found $($FilesFound.Count) files to upload to blob storage."
    exit 1
}
else {
    Write-Output "No new files to upload."
    exit 0
}
