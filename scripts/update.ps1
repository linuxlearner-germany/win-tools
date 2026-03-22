# Windows Updates
Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
Get-WindowsUpdate -Install -AcceptAll -AutoReboot

# Programme updaten
winget upgrade --all

Write-Host "System aktualisiert!"
