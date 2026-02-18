<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Copy-FilesToBlobStorageRemediation
Description: Uploads specified files to Azure Blob Storage using a SAS token
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

# IMPORTANT: Configure these values before deployment
$StorageAccountName = "yourstorageaccount"
$ContainerName = "yourcontainer"
$SasToken = "?sv=2022-11-02&ss=b&srt=o&sp=wac&se=..."  # SAS token with write permissions

# Source paths to upload
$SourcePaths = @(
    "$env:ProgramData\YourApp\Logs",
    "$env:ProgramData\YourApp\Config"
)

# Marker file to track last upload
$MarkerDir = "$env:ProgramData\BlobStorageUpload"
$MarkerFile = "$MarkerDir\lastupload.txt"

if (-not (Test-Path $MarkerDir)) {
    New-Item -Path $MarkerDir -ItemType Directory -Force | Out-Null
}

$BaseUri = "https://$StorageAccountName.blob.core.windows.net/$ContainerName"
$DeviceName = $env:COMPUTERNAME
$UploadCount = 0

foreach ($Path in $SourcePaths) {
    if (-not (Test-Path $Path)) { continue }

    $Files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue

    if (Test-Path $MarkerFile) {
        $LastUpload = Get-Item $MarkerFile | Select-Object -ExpandProperty LastWriteTime
        $Files = $Files | Where-Object { $_.LastWriteTime -gt $LastUpload }
    }

    foreach ($File in $Files) {
        try {
            $BlobName = "$DeviceName/$($File.Name)"
            $UploadUri = "$BaseUri/$BlobName$SasToken"

            $Headers = @{
                "x-ms-blob-type" = "BlockBlob"
                "x-ms-blob-content-type" = "application/octet-stream"
            }

            $FileBytes = [System.IO.File]::ReadAllBytes($File.FullName)
            Invoke-RestMethod -Uri $UploadUri -Method Put -Headers $Headers -Body $FileBytes -ErrorAction Stop
            $UploadCount++
            Write-Output "Uploaded: $BlobName"
        }
        catch {
            Write-Warning "Failed to upload $($File.Name): $_"
        }
    }
}

# Update marker file
Set-Content -Path $MarkerFile -Value (Get-Date).ToString() -Force

Write-Output "Upload complete. $UploadCount files uploaded."
exit 0
