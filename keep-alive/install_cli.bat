@echo off
title Instalar Comando Global Stay Awake
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_cli.ps1" %*
pause
