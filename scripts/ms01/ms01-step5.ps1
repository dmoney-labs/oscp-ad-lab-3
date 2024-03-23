# step 1 create loot in the recycle bin of stuart
Write-Host "Creating loot in the recycle bin..."
Copy-Item "welcome letter.doc" -Destination "C:\Users\stuart\Desktop" -Force
# load the necessary .NET assembly for deleting to the recycle bin
Add-Type -AssemblyName Microsoft.VisualBasic
# Check if the file exists before attempting to delete
$fileWelcomeDoc = "C:\Users\stuart\Desktop\welcome letter.doc"
if (Test-Path $fileWelcomeDoc) { [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($fileWelcomeDoc, [Microsoft.VisualBasic.FileIO.UIOption]::OnlyErrorDialogs, [Microsoft.VisualBasic.FileIO.RecycleOption]::SendToRecycleBin) }
Write-Host "File deleted and moved to the recycle bin: $fileWelcomeDoc"

# step 2: auto logon as local user
$ms01User = "kevin"
$ms01UserPassword = "YellowYellow"
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
