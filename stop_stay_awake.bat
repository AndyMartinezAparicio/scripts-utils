@echo off
title Detener Stay Awake (Emergencia)
echo Buscando y deteniendo procesos de Stay Awake...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$procs = @(Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -match 'keep_alive\.(ps1|py)' }); if ($procs.Count -eq 0) { Write-Host 'No se encontraron procesos activos de Stay Awake.' -ForegroundColor Yellow } else { $procs | ForEach-Object { Stop-Process -Id $_.ProcessId -Force; Write-Host ('Proceso detenido (PID ' + $_.ProcessId + ')') -ForegroundColor Green } }"
echo Listo. Operacion completada.
timeout /t 3
