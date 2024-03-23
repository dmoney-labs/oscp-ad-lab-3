# variables
$domainName = "oscp.lab"
$domainAdminPassword = "3vilLair!"

# step 1: promote to dc
# Import the Active Directory module
Import-Module ADDSDeployment

# Promote to domain controller
$hostname = $currentHostname
Write-Host "Promoting $hostname to a domain controller for $domainName..."
Install-ADDSForest -DomainName $domainName -InstallDns -Force -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText $domainAdminPassword -Force)
Write-Host "$hostname is now a domain controller for $domainName"
Write-Host "This host will not reboot automatically..."
