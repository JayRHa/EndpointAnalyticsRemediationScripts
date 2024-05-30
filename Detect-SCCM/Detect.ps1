# dectection script for SCCM 

# Define the path to ccmsetup.exe
$ccmSetupPath = "$env:windir\ccmsetup\ccmsetup.exe"

# Check if ccmsetup.exe exists
if (Test-Path $ccmSetupPath) {
    Write-Output " SCCM client is installed."
    Exit 1
}
else {
    Write-Output " SCCM client is NOT installed."
    Exit 0
}