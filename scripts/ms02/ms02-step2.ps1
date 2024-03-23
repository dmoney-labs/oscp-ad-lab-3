# step 0: open an administrative powershell window and disable execution protection
# If you can't run this script please enter the following in an administrative powershell window:
# Set-ExecutionPolicy Unrestricted -Force
#
# step 0b: reboot
#########################################
# step 0c: set variables
$ms02Hostname = "ms02"
$ms02IPAddress = "10.10.1.202"

# step 1: configure network settings
Write-Host "Configuring network adapter..."
$adapter1 = Get-NetAdapter -Name Ethernet0
$adapter1 | Set-DnsClientServerAddress -ServerAddresses "10.10.1.200"
if ((Get-NetIPAddress -InterfaceAlias Ethernet0).IPv4Address -ne $ms02IPAddress) {
    $adapter1 | New-NetIPAddress -IPAddress $ms02IPAddress -PrefixLength 24
} else {
    Write-Host "Ethernet0 is already set to $ms02IPAddress"
}

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
# Disable Windows Defender real-time protection and tamper protection
Set-MpPreference -DisableRealtimeMonitoring $true
#Set-MpPreference -DisableTamperProtection $true
Write-Host "Windows Defender real-time protection disabled successfully."

# step 4: set the hostname
#   get the current hostname
$currentHostname = (hostname)
#  check if the current hostname is not set to "ms02"
if ($currentHostname -ne $ms02Hostname) {
    Write-Host "Changing hostname to ms02"
    Rename-Computer -NewName $ms02Hostname -Restart
} else {
    Write-Host "Hostname already set to $ms02Hostname"
}

