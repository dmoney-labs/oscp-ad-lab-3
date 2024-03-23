# OSCP Active Directory Practice Lab #3
# Info
This is my first attempt at sharing some internal scripts I use for quickly building/rebuilding one of the OSCP practice labs. The video for building this is here: [URL] and the video walkthrough of the attack flow is here: https://youtu.be/Q5D2Yjc-RVc

# Requirements
## XAMPP
Please download the xampp installer [https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/8.0.30/xampp-windows-x64-8.0.30-0-VS16-installer.exe] and place it in the ms01 directory.

## mkisofs
mkisofs is used to create the .iso image, however you can use plenty of alternative methods.

# Install
After you've downloaded the XAMPP installer and placed it in the ms01 directory all you need to do is run the following command where 'oscp_ad_lab3_setup.iso' is the resulting .iso file and '-r scripts/' references the directory containing the ms01, ms02, dc01, and shared directories.
mkisofs -o oscp_ad_lab3_setup.iso -J -r scripts/

Also you can reference the youtube video here: [URL]

# BYO Office
What's not included? Office 2019 installer. I used the file Professional2019Retail.img (sha512: 25f10c319762849eed1d8964728205384caadf7f9f55cde2ec906a88d439ebc9c13754888a5c6b64b429d8bd41b8f097f559860fc1e0e7932f728c66d0eb9d8b) which can be found avilable from Microsoft technet or if you do some google-fu ;)

## Help?
I'm not a developer or even a regular github contributer so any input, optimization, and overall guidance is appreciated!


-D
