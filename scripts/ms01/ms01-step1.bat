@echo off
echo Disabling Powershell script execution blocking...
powershell -ep bypass -Command "Set-ExecutionPolicy Unrestricted -Force"
echo Disabled! Proceed with running: ms01-step2.ps1
pause
