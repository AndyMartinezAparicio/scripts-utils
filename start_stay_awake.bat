@echo off
title Stay Awake - Siempre Activo
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0keep_alive.ps1"
pause
