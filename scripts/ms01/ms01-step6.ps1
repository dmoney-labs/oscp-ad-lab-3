# step 1 create user emulation as kevin
# copy the ps1
Write-Host "Creating the user emulation scripts and scheduled task..."
$filePs1 = "$env:USERPROFILE\AppData\Local\user_emulation.ps1"
Copy-Item user_emulation.ps1 -Destination "$env:USERPROFILE\AppData\Local\" -Force
# create the batch file that calls the ps1
$fileBat = "$env:USERPROFILE\AppData\Local\user_emulation.bat"
$fileBatContent = "@echo off"
cmd /c "echo @echo off > $fileBat"
cmd /c "echo powershell.exe -ep bypass -c $env:USERPROFILE\AppData\Local\user_emulation.ps1 >> $fileBat"
# create the scheduled task
schtasks /create /sc minute /mo 3 /tn "User Emulation" /tr "$env:USERPROFILE\AppData\Local\user_emulation.bat"

# step 2 clean up
Write-Host "Cleaning up..."
$user1 = "kevin"
$user2 = "stuart"
Remove-LocalGroupMember -Group "Administrators" -Member $user1
Remove-LocalGroupMember -Group "Administrators" -Member $user2

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

# install office
Write-Host "Now you just need to install Office!"
Write-Host "...and don't forget to enable macros!!"
pause
