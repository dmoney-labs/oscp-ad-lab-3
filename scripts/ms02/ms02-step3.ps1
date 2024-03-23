
# step 1: join the domain
Write-Host "Joining the domain..."
$domain = "oscp.lab"
$domainAdmin = "administrator"
$domainAdminPassword = "3vilLair!"
$domainCredential = New-Object System.Management.Automation.PSCredential($domainAdmin, (ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force))
Add-Computer -DomainName $domain -Credential $domainCredential -Restart
