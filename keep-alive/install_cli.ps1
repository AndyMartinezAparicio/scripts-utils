[CmdletBinding()]
param (
    [switch]$Uninstall
)

$ProjectDir = $PSScriptRoot.TrimEnd('\')
$UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$WindowsAppsDir = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps'

if ($Uninstall) {
    if ($UserPath) {
        $NewPath = ($UserPath -split ';' | Where-Object { $_.TrimEnd('\') -ne $ProjectDir }) -join ';'
        [Environment]::SetEnvironmentVariable('Path', $NewPath, 'User')
    }
    foreach ($cmdName in @('stay-awake.cmd', 'siempre-activo.cmd')) {
        $shim = Join-Path $WindowsAppsDir $cmdName
        if (Test-Path $shim) { Remove-Item $shim -Force -ErrorAction SilentlyContinue }
    }
    Write-Host "[OK] Comandos 'stay-awake' y 'siempre-activo' desinstalados del PATH." -ForegroundColor Yellow
    exit 0
}

# 1. Agregar al PATH del usuario actual (persistente)
$pathEntries = @()
if ($UserPath) { $pathEntries = $UserPath -split ';' | Where-Object { $_ -ne '' } }
if (-not ($pathEntries | Where-Object { $_.TrimEnd('\') -ieq $ProjectDir })) {
    $UpdatedPath = ($pathEntries + $ProjectDir) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $UpdatedPath, 'User')
    Write-Host "[OK] Carpeta agregada al PATH de usuario: $ProjectDir" -ForegroundColor Green
} else {
    Write-Host "[OK] La carpeta ya estaba en el PATH de usuario." -ForegroundColor Cyan
}

# 2. Crear shims en WindowsApps para disponibilidad inmediata sin reiniciar CMD
if (Test-Path $WindowsAppsDir) {
    $shimContent = "@echo off`r`ncall `"$ProjectDir\stay-awake.cmd`" %*`r`n"
    Set-Content -Path (Join-Path $WindowsAppsDir 'stay-awake.cmd') -Value $shimContent -Encoding ASCII
    Set-Content -Path (Join-Path $WindowsAppsDir 'siempre-activo.cmd') -Value $shimContent -Encoding ASCII
    Write-Host "[OK] Shims creados en $WindowsAppsDir (disponibles al instante en cualquier CMD abierto)." -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Comandos globales instalados correctamente:" -ForegroundColor Green
Write-Host "   stay-awake          (o siempre-activo)" -ForegroundColor White
Write-Host "   stay-awake bg       (abre en ventana aparte)" -ForegroundColor White
Write-Host "   stay-awake status   (verifica si esta activo)" -ForegroundColor White
Write-Host "   stay-awake stop     (detiene procesos activos)" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
