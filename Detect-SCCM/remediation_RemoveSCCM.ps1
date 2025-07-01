# dectection script for SCCM 

# Define the path to ccmsetup.exe
$ccmSetupPath = "$env:windir\ccmsetup\ccmsetup.exe"

# Check if ccmsetup.exe exists
if (Test-Path $ccmSetupPath) {
    Write-Output " SCCM client is installed. Removing...."
    Start-Process -FilePath $ccmSetupPath -ArgumentList "/uninstall" -Wait -NoNewWindow
    Write-Output "Congratulations!! The SCCM client uninstalled successfully."
    Exit 1
}
else {
    Write-Output " SCCM client is not installed or the path to ccmsetup.exe is incorrect. Please specify a valid path."
    Exit 0
}


    
