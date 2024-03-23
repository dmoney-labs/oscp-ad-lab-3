@echo off
echo Disabling Powershell script execution blocking...
powershell -ep bypass -Command "Set-ExecutionPolicy Unrestricted -Force"
echo Disabled! Proceed with running: ms02.step1b.ps1
pause
