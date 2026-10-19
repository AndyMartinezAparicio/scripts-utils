@echo off
setlocal
set "PROJECT_DIR=%~dp0"
if "%PROJECT_DIR:~-1%"=="\" set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"

if /I "%~1"=="stop" (
    call "%PROJECT_DIR%\stop_stay_awake.bat"
    exit /b 0
)

if /I "%~1"=="status" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$procs = @(Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -match 'keep_alive\.(ps1|py)' }); if ($procs.Count -eq 0) { Write-Host '[ESTADO] Stay Awake NO esta en ejecucion.' -ForegroundColor Yellow } else { Write-Host ('[ESTADO] Stay Awake ACTIVO (' + $procs.Count + ' proceso(s)):') -ForegroundColor Green; $procs | ForEach-Object { Write-Host ('  - PID ' + $_.ProcessId + ': ' + $_.CommandLine) -ForegroundColor Cyan } }"
    exit /b 0
)

if /I "%~1"=="bg" (
    echo Iniciando Stay Awake en ventana independiente...
    start "Stay Awake (Siempre Activo)" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PROJECT_DIR%\keep_alive.ps1"
    exit /b 0
)

if /I "%~1"=="help" (
    echo Uso de stay-awake ^(o siempre-activo^):
    echo   stay-awake          Inicia Stay Awake en la consola actual
    echo   stay-awake bg       Inicia Stay Awake en una ventana aparte
    echo   stay-awake status   Muestra si Stay Awake esta corriendo actualmente
    echo   stay-awake stop     Detiene todas las instancias activas de Stay Awake
    echo   stay-awake -DryRun  Ejecuta un ciclo de prueba y termina
    exit /b 0
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PROJECT_DIR%\keep_alive.ps1" %*
