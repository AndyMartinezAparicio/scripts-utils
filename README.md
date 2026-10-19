# 🛠️ Scripts Utils

Colección centralizada de scripts utilitarios, herramientas de automatización y comandos CLI para productividad diaria (Windows, Linux y multiplataforma).

Cada herramienta vive en su **propia subcarpeta independiente** con su código fuente, instaladores y su propio archivo README.md detallado.

---

## 📂 Catálogo de Scripts

| Script / Carpeta | Tecnologías | Descripción | Documentación |
|---|---|---|---|
| **[keep-alive](./keep-alive)** | PowerShell (Win32 API) · Python · Batch CLI | Mantiene activa la sesión del sistema y aplicaciones (Teams/Slack) mediante micro-scrolls neutros e invocación a SetThreadExecutionState, con comando global stay-awake / siempre-activo desde cualquier terminal. | [📖 Ver README](./keep-alive/README.md) |

---

## 🧱 Estructura del Repositorio

`	ext
scripts-utils/
├── README.md                  # Índice general de todos los scripts del repositorio
├── LICENSE                    # Licencia MIT global
├── .gitignore                 # Reglas de exclusión (entornos virtuales, cachés, etc.)
└── keep-alive/                # Script: Mantener sesión activa (Stay Awake)
    ├── README.md              # Documentación específica de keep-alive
    ├── keep_alive.ps1         # Versión nativa para Windows (0 dependencias)
    ├── keep_alive.py          # Versión multiplataforma en Python
    ├── stay-awake.cmd         # Comando CLI global (start, bg, status, stop)
    ├── siempre-activo.cmd     # Alias CLI en español
    ├── install_cli.ps1        # Instalador del comando global en PATH
    ├── install_cli.bat        # Lanzador de 1 clic para instalar el CLI
    ├── start_stay_awake.bat   # Inicio rápido con doble clic
    ├── stop_stay_awake.bat    # Parada de emergencia con doble clic
    └── requirements.txt       # Dependencias opcionales para la versión Python
`

---

## 🚀 Cómo agregar un nuevo script

Para mantener el repositorio ordenado y modular, cada nuevo script sigue esta convención:

1. Crea una carpeta con el nombre del script en formato kebab-case (por ejemplo, limpiador-archivos/ o ackup-db/).
2. Añade dentro el script y un archivo **README.md** propio explicando:
   - Qué problema resuelve.
   - Requisitos (si los tiene).
   - Cómo ejecutarlo y ejemplos de uso.
3. Registra una fila nueva en la tabla **[Catálogo de Scripts](#-catálogo-de-scripts)** de este README.md principal.

---

## 📄 Licencia

Este repositorio se distribuye bajo la licencia [MIT](./LICENSE).
