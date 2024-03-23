# step 0: open an administrative powershell window and disable execution protection
# Set-ExecutionPolicy Unrestricted -Force
# step 0b: reboot
#########################################
# step 1: configure network settings
Write-Host "Configuring network adapter..."
$ipAddress = "10.10.1.200"
$adapter1 = Get-NetAdapter -Name Ethernet0
if ((Get-NetIPAddress -InterfaceAlias Ethernet0).IPv4Address -ne $ipAddress) {
    $adapter1 | New-NetIPAddress -IPAddress $ipAddress -PrefixLength 24
}
$adapter1 | Set-DnsClientServerAddress -ServerAddresses "127.0.0.1"
Write-Host "Ethernet0 is already set to $ipAddress"

# step 2: disable screen saver and timeouts
Write-Host "Disabling screen saver..."
# Disable the screen saver
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name ScreenSaveActive -Value 0

# Disable the screen saver timeout
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name ScreenSaveTimeOut -Value 0

# Disable the display timeout
powercfg -change -standby-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
Write-Host "Screen saver disabled successfully."

# step 3: install active directory and promote to a domain controller
# Install Active Directory Domain Services role
Write-Host "Installing Active Directory Domain Services role..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Restart

# step 4: configure the hostname
#   get the current hostname
$currentHostname = (hostname)
#  check if the current hostname is not set to "ms01"
if ($currentHostname -ne "dc01") {
    Write-Host "Changing hostname to dc01"
    Rename-Computer -NewName dc01 -Restart
} else {
    Write-Host "Hostname already set to dc01"
}

