# 🖱️ Stay Awake

Script ligero y discreto para mantener activa la sesión de tu PC evitando que se suspenda, bloquee o marque tu estado como ausente (inactivo). 

Funciona realizando **micro-scrolls indetectables y neutros** (hacia abajo y de vuelta hacia arriba) en intervalos de tiempo aleatorios (**nunca mayores a 15 segundos**), preservando exactamente tu posición de lectura y ventana activa.

---

## ✨ Características principales

- 🎲 **Intervalos aleatorios (≤ 15s):** Cada ciclo espera un tiempo aleatorio entre 5 y 15 segundos (configurable), simulando un patrón de actividad orgánico y natural.
- 🔄 **Efecto neutro y sin desplazamiento acumulado:** Realiza un micro-scroll hacia abajo y, tras una pausa imperceptible (~250 ms), regresa exactamente la misma distancia hacia arriba. Tu pantalla permanece en la misma posición.
- 🪟 **Versión nativa para Windows (0 dependencias):** Scripts listos para usar en PowerShell y Batch (`keep_alive.ps1` y `start_stay_awake.bat`). Combina micro-scrolls (`mouse_event`) con `SetThreadExecutionState` (`kernel32.dll`) para evitar tanto el estado ausente (Teams/Slack) como el bloqueo de pantalla corporativo.
- 💻 **Comando global desde cualquier terminal (`stay-awake` / `siempre-activo`):** Incluye instalador (`install_cli.bat` / `install_cli.ps1`) para invocar `stay-awake`, `stay-awake bg`, `stay-awake status` o `stay-awake stop` desde cualquier `cmd` o PowerShell sin navegar a la carpeta.
- 🐍 **Versión en Python (Multiplataforma):** Script multiplataforma (`keep_alive.py`) compatible con Windows, macOS y Linux, con argumentos personalizables por línea de comandos.
- 🛑 **Parada segura cuádruple:** Se detiene limpiamente con `Ctrl + C`, teclas `ESC`/`Q`, llevando el ratón a la esquina `(0,0)` o con `stay-awake stop` / `stop_stay_awake.bat`.

---

## 📁 Estructura del proyecto

```text
stay-awake/
├── start_stay_awake.bat   # Lanzador rápido con doble clic para Windows
├── stop_stay_awake.bat    # Botón de pánico / Parada de emergencia (1 clic)
├── keep_alive.ps1         # Script nativo en PowerShell (sin dependencias)
├── keep_alive.py          # Script en Python multiplataforma
├── requirements.txt       # Dependencias para la versión en Python
└── README.md              # Documentación del proyecto
```

---

## 🚀 Guía de uso rápido

Puedes elegir la alternativa que mejor se adapte a tu entorno:

### Opción A: Windows nativo (Sin instalar nada / Doble clic)

Ideal si estás en una computadora corporativa o no tienes Python instalado:

1. **Vía Explorador de archivos (Doble clic):**
   - Haz doble clic sobre `start_stay_awake.bat`. Se abrirá una ventana de consola ejecutando el script con la configuración predeterminada.
2. **Vía terminal PowerShell:**
   - Abre PowerShell en la carpeta del proyecto y ejecuta:
     ```powershell
     powershell -ExecutionPolicy Bypass -File .\keep_alive.ps1 -MinSeconds 5 -MaxSeconds 15 -Notches 2
     ```

> **Parámetros disponibles en PowerShell:**
> - `-MinSeconds <int>`: Tiempo mínimo de espera por ciclo en segundos (por defecto: `5`).
> - `-MaxSeconds <int>`: Tiempo máximo de espera por ciclo en segundos (por defecto: `15`).
> - `-Notches <int>`: Intensidad del desplazamiento de rueda del ratón (por defecto: `2`).

---

### Opción B: Python (Windows / macOS / Linux)

Ideal para entornos multiplataforma o si prefieres el ecosistema Python:

1. **Instalar dependencias:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Ejecutar con valores por defecto (entre 5 y 15 segundos):**
   ```bash
   python keep_alive.py
   ```

3. **Personalizar parámetros por consola:**
   ```bash
   python keep_alive.py --min-interval 3 --max-interval 15 --clicks 3
   ```

> **Opciones disponibles en Python:**
> - `--min-interval <float>`: Intervalo mínimo en segundos (por defecto: `5.0`).
> - `--max-interval <float>`: Intervalo máximo en segundos (por defecto: `15.0`).
> - `--clicks <int>`: Clics / notches de micro-scroll por movimiento (por defecto: `2`).
> - `--dry-run`: Modo prueba para registrar ciclos en la terminal sin simular eventos de hardware.

---

## 🛑 Cómo detener el script (4 métodos seguros)

Incluso si `Ctrl + C` no responde de inmediato en tu consola, dispones de múltiples salvaguardas inmediatas:

1. 🎯 **Esquina de emergencia `(0,0)`:** Lleva el ratón a la esquina superior izquierda de tu pantalla. Tanto en PowerShell como en Python, el script comprueba esta posición cada 0.2 segundos y se detiene automáticamente.
2. ⌨️ **Teclas `ESC` o `Q`:** Si estás en la ventana de PowerShell, presiona `ESC` o `Q` en cualquier momento para finalizar.
3. 🛑 **Botón de pánico (`stop_stay_awake.bat`):** Haz doble clic en `stop_stay_awake.bat` para buscar y cerrar forzosamente cualquier instancia de Stay Awake activa en segundo plano.
4. ❌ **`Ctrl + C` o cerrar la ventana:** Atajo estándar de consola o simplemente cerrar la ventana de la terminal.

---

## 📦 Publicar en GitHub

Si deseas subir este proyecto a un nuevo repositorio en GitHub:

```bash
git init
git add .
git commit -m "feat: initial commit for stay-awake"
git branch -M main
git remote add origin https://github.com/<tu-usuario>/stay-awake.git
git push -u origin main
```

---

## 📄 Licencia

Este proyecto es de código abierto bajo la licencia [MIT](LICENSE) (o de dominio público para uso personal y educativo).
