# set vars
$drive = "D:" # UPDATE THIS TO MATCH YOUR CD DRIVE

# step 1: create AD users and groups
Write-Host "Creating AD users..."
# Import the Active Directory module
Import-Module ADDSDeployment
# not in rockyou
New-ADUser -Name "Gru" -GivenName "Gru" -Surname "" -SamAccountName "gru" -UserPrincipalName "gru@oscp.lab" -AccountPassword (ConvertTo-SecureString -AsPlainText "M!n1onB0ss" -Force) -Enabled $true

# not in rockyou
New-ADUser -Name "Lucy" -GivenName "Lucy" -Surname "Wilde" -SamAccountName "lucy" -UserPrincipalName "lucy@oscp.lab" -AccountPassword (ConvertTo-SecureString -AsPlainText "Password123@" -Force) -Enabled $true

# not in rockyou
New-ADUser -Name "Dr Nefario" -GivenName "Dr" -Surname "Nefario" -SamAccountName "dr_nefario" -UserPrincipalName "dr_nefario@oscp.lab" -AccountPassword (ConvertTo-SecureString -AsPlainText "Allth3G@dgets" -Force) -Enabled $true

# not in rockyou
New-ADUser -Name "Margo" -GivenName "Margo" -Surname "" -SamAccountName "margo" -UserPrincipalName "margo@oscp.lab" -AccountPassword (ConvertTo-SecureString -AsPlainText "bigS1&ter" -Force) -Enabled $true

# not in rockyou
New-ADUser -Name "Edith" -GivenName "Edith" -Surname "" -SamAccountName "edith" -UserPrincipalName "edith@oscp.lab" -AccountPassword (ConvertTo-SecureString -AsPlainText "!tPoked4HoleInMyJuiceBox" -Force) -Enabled $true

# not in rockyou
New-ADUser -Name "Agnes" -GivenName "Agnes" -Surname "" -SamAccountName "agnes" -UserPrincipalName "agnes@oscp.lab" -AccountPassword (ConvertTo-SecureString -AsPlainText "s0FLUFFY!!!" -Force) -Enabled $true

# not in rockyou
New-ADUser -Name "Minions" -GivenName "Minions" -Surname "" -SamAccountName "minions" -UserPrincipalName "minions@oscp.lab" -AccountPassword (ConvertTo-SecureString -AsPlainText "B4nan@!!!" -Force) -Enabled $true
Write-Host "AD users created"

# step 2: install and configure LAPS
# install LAPS
$msiLAPS = $drive + "\shared\LAPS.x64.msi"
Write-Host "Please install LAPS with ==ALL== the options..."
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $msiLAPS /norestart" -Wait

Write-Host "Modifying Active Directory permissions..."
# extend the AD schema
Import-Module AdmPwd.ps
Update-AdmPwdADSchema

# give computer accounts the ability to write their own password updates
Set-AdmPwdComputerSelfPermission -OrgUnit "CN=Computers,DC=oscp,DC=lab"

# create new ad group for users that will have read access
Write-Host "Adding LAPS groups, assigning users, and assigning permissions..."
$lapsGroupAdmins = "LAPS Admins"
$lapsGroupUsers = "LAPS Users"
$lapsUser = "minions"
New-ADGroup -name $lapsGroupUsers -GroupCategory Security -GroupScope Global
# optional group for read/write access
New-ADGroup -name $lapsGroupAdmins -GroupCategory Security -GroupScope Global

# add users to the LAPS Users group
Import-Module ActiveDirectory
Add-ADGroupMember -Identity $lapsGroupUsers -Members $lapsUser

# set read permissions
Set-AdmPwdReadPasswordPermission -OrgUnit "CN=Computers,DC=oscp,DC=lab" -AllowedPrincipals 'LAPS Admins','LAPS Users'

# set write permissions (reset password)
Set-AdmPwdResetPasswordPermission -OrgUnit "CN=Computers,DC=oscp,DC=lab" -AllowedPrincipals 'LAPS Admins'

# create dir and copy policy definitions over
Write-Host "Copying AdmPwd files to SYSVOL..."
mkdir \\oscp.lab\SYSVOL\oscp.lab\Policies\PolicyDefinitions -ErrorAction SilentlyContinue
copy C:\Windows\PolicyDefinitions\AdmPwd.admx '\\oscp.lab\SYSVOL\oscp.lab\Policies\PolicyDefinitions\'

mkdir \\oscp.lab\SYSVOL\oscp.lab\Policies\PolicyDefinitions\en-US -ErrorAction SilentlyContinue
copy C:\Windows\PolicyDefinitions\en-US\AdmPwd.adml '\\oscp.lab\SYSVOL\oscp.lab\Policies\PolicyDefinitions\en-US\'

# now create and assign a GPO to configure the workstations
Write-Host "Creating Group Policy Objects and linking to the domain..."
# Import the GroupPolicy module
Import-Module GroupPolicy

# Specify the GPO name and domain
$gpoName = "OSCP GPO"
$domainName = "oscp.lab"

# Create a new GPO
$gpo = New-GPO -Name $gpoName

# Link the GPO to the domain
$domainDN = "dc=oscp,dc=lab"
New-GPLink -Name $gpoName -Target $domainDN -Enforced No

Write-Host "GPO '$gpoName' created and linked to the domain '$domainName'."
Write-Host "Now YOU need to configure the following settings: "
Write-Host "Computer Configuration > Polices > Administrative Templates > LAPS > Password Settings = Enabled"
Write-Host "Name of administrator account to manage = Enabled"
Write-Host " - Administrator account name = LAPSAdmin"
Write-Host "Enable local admin password management = Enabled"
Start-Process -FilePath "gpmc.msc"
Write-Host "All Finished!"
