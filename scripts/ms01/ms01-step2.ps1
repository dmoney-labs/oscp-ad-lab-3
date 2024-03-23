# step 0c: set variables
$ms01Hostname = "ms01"
$ms01IPAddressOutside = "192.168.100.201"
$ms01IPAddressInside = "10.10.1.201"
$dc01IP = "10.10.1.200"

# step 1: configure network settings
Write-Host "Configuring network adapters..."
$adapter1 = Get-NetAdapter -Name Ethernet0
if ((Get-NetIPAddress -InterfaceAlias Ethernet0).IPv4Address -ne $ms01IPAddressOutside) {
    $adapter1 | New-NetIPAddress -IPAddress $ms01IPAddressOutside -PrefixLength 24
} else {
    Write-Host "Ethernet0 is already set to $ms01IPAddress"
}
$adapter2 = Get-NetAdapter -Name Ethernet1
if ((Get-NetIPAddress -InterfaceAlias Ethernet1).IPv4Address -ne $ms01IPAddressInside) {
    $adapter2 | New-NetIPAddress -IPAddress $ms01IPAddressInside -PrefixLength 24
} else {
    Write-Host "Ethernet1 is already set to $ms01IPAddressInside"
}
$adapter2 | Set-DnsClientServerAddress -ServerAddresses $dc01IP

# add route to openvpn remote access subnet (if you use it)
Write-Host "Configuring route to openvpn subnet..."
$netOpenVPN = "172.16.11.0"
$netOpenVPNMask = "255.255.255.0"
$openVPNServer = "192.168.100.199"
route add $netOpenVPN mask $netOpenVPNMask $openVPNServer /p

# step 2:
# Disable the screen saver
Write-Host "Disabling screen saver..."
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name ScreenSaveActive -Value 0

# Disable the screen saver timeout
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name ScreenSaveTimeOut -Value 0

# Disable the display timeout
powercfg -change -standby-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
Write-Host "Screen saver disabled successfully."

# step 3:
Write-Host "Disabling Windows Defender real-time protection..."
# Disable Windows Defender real-time protection and tamper protection
Set-MpPreference -DisableRealtimeMonitoring $true
#Set-MpPreference -DisableTamperProtection $true
Write-Host "Windows Defender real-time protection disabled successfully."

# step 4: set the hostname
#   get the current hostname
$currentHostname = (hostname)
#  check if the current hostname is not set to "ms01"
if ($currentHostname -ne $ms01Hostname) {
    Write-Host "Changing hostname to $ms01Hostname"
    Rename-Computer -NewName $ms01Hostname -Restart
} else {
    Write-Host "Hostname already set to $ms01Hostname"
}
pause
