<#
.SYNOPSIS
    Stay Awake (Siempre Activo) - Script nativo en PowerShell.
.DESCRIPTION
    Mantiene la sesion activa mediante micro-desplazamientos neutrales de la rueda del raton (scroll abajo y arriba),
    sin dependencias externas utilizando la API Win32 mouse_event.
#>

[CmdletBinding()]
param (
    [double]$MinSeconds = 5.0,
    [double]$MaxSeconds = 15.0,
    [int]$Notches = 2,
    [switch]$DryRun
)

# Validar y restringir intervalo maximo a 15 segundos
if ($MaxSeconds -gt 15.0) {
    Write-Host "[AVISO] MaxSeconds ($MaxSeconds) supera el limite de 15.0s. Ajustado automaticamente a 15.0s." -ForegroundColor Yellow
    $MaxSeconds = 15.0
}
if ($MinSeconds -gt $MaxSeconds) {
    Write-Host "[AVISO] MinSeconds ($MinSeconds) superaba MaxSeconds ($MaxSeconds). Ajustado al valor maximo." -ForegroundColor Yellow
    $MinSeconds = $MaxSeconds
}
if ($MinSeconds -lt 0.5) {
    $MinSeconds = 0.5
}

# Definicion e incorporacion del tipo C# para invocar user32.dll mouse_event y GetCursorPos
$TypeDef = @"
using System;
using System.Runtime.InteropServices;

public class NativeMouseControl {
    public const uint MOUSEEVENTF_WHEEL = 0x0800;
    public const uint ES_CONTINUOUS = 0x80000000;
    public const uint ES_SYSTEM_REQUIRED = 0x00000001;
    public const uint ES_DISPLAY_REQUIRED = 0x00000002;

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, int cButtons, uint dwExtraInfo);

    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern uint SetThreadExecutionState(uint esFlags);

    public static bool IsTopLeftCorner() {
        POINT p;
        if (GetCursorPos(out p)) {
            return p.X <= 5 && p.Y <= 5;
        }
        return false;
    }

    public static void Scroll(int delta) {
        mouse_event(MOUSEEVENTF_WHEEL, 0, 0, delta, 0);
    }

    public static void PreventSleep() {
        SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);
    }

    public static void RestoreSleep() {
        SetThreadExecutionState(ES_CONTINUOUS);
    }
}
"@

try {
    Add-Type -TypeDefinition $TypeDef -ErrorAction Stop
} catch {
    # Si el tipo ya existe en la sesion actual de PowerShell, continuamos sin error
    if (-not ([System.Management.Automation.PSTypeName]'NativeMouseControl').Type) {
        throw $_
    }
}

function Invoke-NeutralScroll {
    param ([int]$Count)
    $deltaPerNotch = 120
    $totalDelta = $deltaPerNotch * $Count

    [NativeMouseControl]::PreventSleep()
    # Desplazar hacia abajo
    [NativeMouseControl]::Scroll(-$totalDelta)
    Start-Sleep -Milliseconds 250
    # Desplazar hacia arriba (posicion neutral)
    [NativeMouseControl]::Scroll($totalDelta)
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Stay Awake (Siempre Activo) - PowerShell Nativo" -ForegroundColor Cyan
Write-Host " Intervalo aleatorio: $MinSeconds s - $MaxSeconds s | Notches: $Notches" -ForegroundColor Cyan
Write-Host " Presiona Ctrl+C, tecla ESC/Q, o lleva el raton a (0,0) para detener." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if ($DryRun) {
    $now = (Get-Date).ToString("HH:mm:ss")
    Invoke-NeutralScroll -Count $Notches
    [NativeMouseControl]::RestoreSleep()
    Write-Host "[$now] [DRY-RUN] Scroll +/- completado con exito ($Notches notches). Prueba finalizada." -ForegroundColor Green
    exit 0
}

try {
    while ($true) {
        if ([NativeMouseControl]::IsTopLeftCorner()) {
            Write-Host "`n[PARADA DE EMERGENCIA] Raton en esquina superior izquierda (0,0). Deteniendo script..." -ForegroundColor Red
            exit 0
        }
        try {
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq 'Escape' -or $key.Key -eq 'Q') {
                    Write-Host "`n[INFO] Detenido con tecla $($key.Key). !Hasta luego!" -ForegroundColor Yellow
                    exit 0
                }
            }
        } catch { }

        Invoke-NeutralScroll -Count $Notches

        # Generar intervalo aleatorio con resolucion de 0.1s
        $minInt = [int]($MinSeconds * 10)
        $maxInt = [int]($MaxSeconds * 10)
        $randInt = Get-Random -Minimum $minInt -Maximum ($maxInt + 1)
        $waitSec = [math]::Round($randInt / 10.0, 1)

        $timeNow = (Get-Date).ToString("HH:mm:ss")
        Write-Host "[$timeNow] Scroll +/- completado ($Notches notches). Proximo pulso en ${waitSec}s..." -ForegroundColor Gray

        # Bucle de espera reactivo en pasos de 200ms
        $totalWaitMs = [int]($waitSec * 1000)
        $elapsedMs = 0
        while ($elapsedMs -lt $totalWaitMs) {
            $stepMs = [math]::Min(200, $totalWaitMs - $elapsedMs)
            Start-Sleep -Milliseconds $stepMs
            $elapsedMs += $stepMs

            if ([NativeMouseControl]::IsTopLeftCorner()) {
                Write-Host "`n[PARADA DE EMERGENCIA] Raton en esquina superior izquierda (0,0). Deteniendo script..." -ForegroundColor Red
                exit 0
            }
            try {
                if ([Console]::KeyAvailable) {
                    $key = [Console]::ReadKey($true)
                    if ($key.Key -eq 'Escape' -or $key.Key -eq 'Q') {
                        Write-Host "`n[INFO] Detenido con tecla $($key.Key). !Hasta luego!" -ForegroundColor Yellow
                        exit 0
                    }
                }
            } catch { }
        }
    }
} catch {
    Write-Host "`n[INFO] Ejecucion detenida por el usuario. !Hasta luego!" -ForegroundColor Yellow
} finally {
    [NativeMouseControl]::RestoreSleep()
}
