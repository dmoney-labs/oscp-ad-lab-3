# step 1: install LAPS
$lapsAdmin = "LAPSAdmin"
$msiLAPS = "../shared/LAPS.x64.msi"
if ((Get-LocalUser -Name $lapsAdmin -ErrorAction SilentlyContinue) -eq $false) {
    Write-Host "Installing LAPS..."
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $msiLAPS CUSTOMADMINNAME=$adminLAPS" -Wait
}
# step 2: expose a web service
$exeXampp = "xampp-windows-x64-8.0.30-0-VS16-installer.exe"
$batApacheSvc = "apache_installservice.bat"
$dirApache = "C:\xampp\apache\"
if ((Test-Path -Path $dirApache) -eq $false ) {
    Write-Host "Installing XAMPP..."
    Start-Process -FilePath $exeXampp -Wait
}
Start-Process -FilePath $batApacheSvc -Wait -WorkingDirectory $dirApache

$dirHtdocs = "C:\xampp\htdocs"
$dirUploads = "C:\xampp\htdocs\uploads"
Write-Host "Creating vulnerable web service..."
Remove-Item $dirHtdocs\* -Include *.html,*.php -Force
Copy-Item index.html -Destination "C:\xampp\htdocs\" -Force
Copy-Item upload.php -Destination "C:\xampp\htdocs\" -Force
New-Item -ItemType Directory -Path $dirUploads

Write-Host "Adding firewall exceptions for tcp/80 and tcp/443..."
netsh advfirewall firewall add rule name="Web Service Port 80" dir=in action=allow protocol=tcp localport=80
netsh advfirewall firewall add rule name="Web Service Port 443" dir=in action=allow protocol=tcp localport=443

# step 3: auto logon as local user
$ms01User = "stuart"
$ms01UserPassword = "0ne3ye!"
$domain = "ms01"
$exeAutorun64 = "..\shared\Autologon64.exe"
Write-Host "Setting workstation to autologon as $ms01User..."
Start-Process -FilePath $exeAutorun64 -ArgumentList "$ms01User $domain $ms01UserPassword /AcceptEULA"

$userConfirmation2 = Read-Host "All done. Would you like to reboot now? (Y/N)"
# Check the user's response
if ($userConfirmation -eq 'Y' -or $userConfirmation2 -eq 'y') {
    # reboot
    Restart-Computer -Force
    Write-Host "Rebooting..."
} else {
    Write-Host "Reboot cancelled."
}
pause
