# Enable PowerShell Script Execution
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Set the screen timeout to 60 minutes (3600 seconds)
Write-Host "Configuring screen lock timeout to 60 minutes..."
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveTimeOut" -Value "3600" -PropertyType String -Force | Out-Null

# Enable the screensaver
Write-Host "Enabling screensaver..."
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveActive" -Value "1" -PropertyType String -Force | Out-Null

# Set screensaver password protection
Write-Host "Enabling password protection on resume..."
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaverIsSecure" -Value "1" -PropertyType String -Force | Out-Null

# Confirm changes
Write-Host "Screen lock and password protection settings applied."

# Refresh user policy to ensure immediate effect
Write-Host "Refreshing policy to apply changes..."
rundll32.exe user32.dll, LockWorkStation

Write-Host "Configuration complete!"
