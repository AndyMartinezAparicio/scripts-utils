"""
Stay Awake (Siempre Activo) - Script en Python
Simula actividad de usuario mediante pulsos breves de desplazamiento (scroll)
arriba y abajo para mantener la sesion activa sin alterar la posicion visual.
"""

import argparse
import random
import sys
import time
from datetime import datetime

try:
    import pyautogui
    pyautogui.FAILSAFE = True
except ImportError:
    pyautogui = None


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Stay Awake - Mantiene activa la sesion mediante micro-desplazamientos del raton.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "--min-interval",
        type=float,
        default=5.0,
        help="Intervalo minimo en segundos entre cada pulso de scroll.",
    )
    parser.add_argument(
        "--max-interval",
        type=float,
        default=15.0,
        help="Intervalo maximo en segundos entre cada pulso de scroll (por defecto <= 15.0s).",
    )
    parser.add_argument(
        "--clicks",
        type=int,
        default=3,
        help="Cantidad de notches/clics de rueda a desplazar hacia abajo y arriba.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Ejecuta 1 ciclo de prueba sin requerir ejecucion de raton ni generar esperas, finalizando de inmediato.",
    )
    parser.add_argument(
        "--allow-over-15s",
        action="store_true",
        help="Permite anular el limite de seguridad de maximo 15 segundos.",
    )
    return parser.parse_args()


def perform_scroll(clicks: int) -> None:
    """Ejecuta un desplazamiento hacia abajo y luego hacia arriba por la misma cantidad."""
    if pyautogui is None:
        raise RuntimeError(
            "La libreria 'pyautogui' no esta instalada. Ejecuta: pip install -r requirements.txt"
        )
    # Scroll hacia abajo
    pyautogui.scroll(-clicks)
    time.sleep(0.25)
    # Scroll hacia arriba (neutraliza la posicion)
    pyautogui.scroll(clicks)


def main() -> None:
    args = parse_arguments()

    # Validacion y restriccion de intervalos
    if not args.allow_over_15s and args.max_interval > 15.0:
        print("[AVISO] El intervalo maximo supera el limite de 15.0s. Ajustado automaticamente a 15.0s.")
        args.max_interval = 15.0

    if args.min_interval > args.max_interval:
        print(f"[AVISO] Min-interval ({args.min_interval}s) era mayor que max-interval ({args.max_interval}s). Ajustando min a max.")
        args.min_interval = args.max_interval

    if args.min_interval < 0.5:
        args.min_interval = 0.5

    now_str = datetime.now().strftime("%H:%M:%S")

    # Modo Dry-Run para verificacion rapida sin ejecutar movimientos fisicos ni requerir pyautogui
    if args.dry_run:
        sample_wait = round(random.uniform(args.min_interval, args.max_interval), 1)
        print(f"[{now_str}] [DRY-RUN] Simulacion de scroll +/- completada ({args.clicks} notches). Proximo pulso simulado en {sample_wait:.1f}s.")
        print("[DRY-RUN] Ciclo de prueba finalizado con exito.")
        sys.exit(0)

    # Modo ejecucion normal: verificar que pyautogui este disponible
    if pyautogui is None:
        print(
            "[ERROR] La libreria 'pyautogui' no esta disponible en el entorno.\n"
            "Instala las dependencias necesarias con:\n"
            "    pip install -r requirements.txt\n"
            "O utiliza la version nativa de PowerShell (keep_alive.ps1) que no requiere dependencias.",
            file=sys.stderr,
        )
        sys.exit(1)

    print("=" * 60)
    print(" Stay Awake (Siempre Activo) - Script Python")
    print(f" Intervalo aleatorio: {args.min_interval:.1f}s - {args.max_interval:.1f}s | Clics: {args.clicks}")
    print(" Presiona Ctrl+C para detener la ejecucion.")
    print("=" * 60)

    try:
        while True:
            try:
                perform_scroll(args.clicks)
            except Exception as e:
                if pyautogui and hasattr(pyautogui, "FailSafeException") and isinstance(e, pyautogui.FailSafeException):
                    print("\n[PARADA DE EMERGENCIA] Raton en esquina superior izquierda (0,0). Deteniendo script...")
                    sys.exit(0)
                raise

            wait_time = round(random.uniform(args.min_interval, args.max_interval), 1)
            time_now = datetime.now().strftime("%H:%M:%S")
            print(f"[{time_now}] Scroll ↑↓ completado ({args.clicks} notches). Proximo pulso en {wait_time:.1f}s...")

            # Bucle de espera reactivo en pasos de 0.2s para detectar la esquina de emergencia (0,0)
            elapsed = 0.0
            while elapsed < wait_time:
                step = min(0.2, wait_time - elapsed)
                time.sleep(step)
                elapsed += step
                if pyautogui is not None:
                    pos = pyautogui.position()
                    if pos.x <= 5 and pos.y <= 5:
                        print("\n[PARADA DE EMERGENCIA] Raton en esquina superior izquierda (0,0). Deteniendo script...")
                        sys.exit(0)
    except KeyboardInterrupt:
        print("\n[INFO] Ejecucion detenida por el usuario (Ctrl+C). !Hasta luego!")
        sys.exit(0)
    except Exception as e:
        if pyautogui and hasattr(pyautogui, "FailSafeException") and isinstance(e, pyautogui.FailSafeException):
            print("\n[PARADA DE EMERGENCIA] Raton en esquina superior izquierda (0,0). Deteniendo script...")
            sys.exit(0)
        raise


if __name__ == "__main__":
    main()
