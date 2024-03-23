# step 1 local user accounts
# define the usernames and passwords
$user1 = "kevin"
$user2 = "stuart"
$password1 = "YellowYellow" | ConvertTo-SecureString -AsPlainText -Force
$password2 = "0ne3ye!" | ConvertTo-SecureString -AsPlainText -Force
# create user accounts
Write-Host "Creating local users..."
if (Get-LocalUser -Name $user1 -ErrorAction SilentlyContinue) {
} else {
    New-LocalUser -Name $user1 -Password $password1
}
if (Get-LocalUser -Name $user2 -ErrorAction SilentlyContinue) {
} else {
    New-LocalUser -Name $user2 -Password $password2
}
# add the user(s) to groups
if (Get-LocalGroupMember -Name "Administrators" -Member $user1) {
} else {
    Add-LocalGroupMember -Group "Administrators" -Member $user1
    Add-LocalGroupMember -Group "Administrators" -Member $user2
}
# print local administrators members
Get-LocalGroupMember -Group Administrators

# step 2 join the domain
Write-Host "Joining the domain..."
$domain = "oscp.lab"
$domainAdmin = "administrator"
$domainAdminPassword = "3vilLair!"
$domainCredential = New-Object System.Management.Automation.PSCredential($domainAdmin, (ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force))
Add-Computer -DomainName $domain -Credential $domainCredential -Restart
