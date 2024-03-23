# set vars
$drive = "D:" # UPDATE THIS TO MATCH YOUR CD DRIVE

# step 1: vulnerable lateral movement
Write-Host "Creating local users and groups..."
# add Lucy as member of local admins
$user1 = "oscp\lucy"
# add the user(s) to groups
Add-LocalGroupMember -Group "Remote Desktop Users" -Member $user1
# print local administrators members
Get-LocalGroupMember -Group "Remote Desktop Users"

# enable remote desktop
Write-Host "Enabling RDP..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 0 /f

#enable rdp firewall rule
netsh advfirewall firewall set rule group="remote desktop" new enable=yes

# step 2: install LAPS
Write-Host "Installing LAPS..."
$msiLAPS = $drive + "\shared\LAPS.x64.msi"
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $msiLAPS CUSTOMADMINNAME=LAPSAdmin" -Wait

# step 3: cached domain admin creds
Write-Host "Setting auto logon as oscp\gru"
$domainAdmin = "gru"
$domainAdminPassword = "M!n1onB0ss"
$domain = "oscp.lab"
$exeAutorun64 = $drive + "\shared\Autologon64.exe"
Start-Process -FilePath $exeAutorun64 -ArgumentList "$domainAdmin $domain $domainAdminPassword /AcceptEULA"

# final step = delete deleteme
# Prompt the user for confirmation
$userConfirmation = Read-Host "Are you sure you want to delete the 'deleteme' user? (Y/N)"
# Check the user's response
if ($userConfirmation -eq 'Y' -or $userConfirmation -eq 'y') {
    # Delete the local user account
    Remove-LocalUser -Name "deleteme" -Confirm:$false  # Confirm:$false suppresses the confirmation prompt
    Write-Host "User 'deleteme' has been deleted."
} else {
    Write-Host "User deletion cancelled."
}

$userConfirmation2 = Read-Host "All done. Would you like to reboot now? (Y/N)"
# Check the user's response
if ($userConfirmation -eq 'Y' -or $userConfirmation2 -eq 'y') {
    # reboot
    Restart-Computer -Force
    Write-Host "Rebooting..."
} else {
    Write-Host "Reboot cancelled."
}
