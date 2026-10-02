# Proposal

## Why

Un equipo Fedora Workstation recién instalado necesita un punto de entrada pequeño, repetible y seguro antes de ampliar su configuración personal. Esta primera iteración elimina la preparación manual del entorno base sin sustituir archivos no gestionados ni versionar secretos.

## What Changes

- Incorporar `./bootstrap` para validar Fedora Workstation con GNOME, mostrar un plan y, tras confirmación, preparar `$HOME/.dotfiles`.
- Instalar únicamente las dependencias base `git`, `curl`, `zsh`, `flatpak`, `gum`, las herramientas de Dotbot y el grupo de compilación requerido por Homebrew; Gum mejora la interfaz cuando ya está disponible.
- Crear el scaffold declarativo de carpetas y las plantillas Nautilus de texto, Markdown y shell.
- Preparar Dotbot sin reemplazar destinos no gestionados: los conflictos se detienen hasta confirmación humana explícita.
- Preparar los catálogos separados DNF/RPM, Flatpak, Homebrew y AppImage; instalar Homebrew, activar su entorno de forma idempotente para Bash y Zsh, y configurar las fuentes externas declaradas necesarias, sin instalar el catálogo completo.
- Instalar Bitwarden CLI mediante Homebrew e integrar Vaultwarden y GNOME Keyring como fase final sin bloquear el bootstrap base.
- Mantener operaciones idempotentes, diagnósticos en español, salida ASCII legible, pruebas automatizadas y documentación del bootstrap.

## Capabilities

### New Capabilities
- `fedora-bootstrap`: valida Fedora Workstation con GNOME y ejecuta el bootstrap compatible con la referencia solicitada.
- `package-sources`: declara las fuentes de software y prepara las dependencias y catálogos base por distribuidor.
- `workstation-configuration`: crea el scaffold y las plantillas iniciales, y gestiona conflictos de enlaces Dotbot.
- `vaultwarden-session`: configura Vaultwarden de forma opcional y mantiene una sesión revocable en GNOME Keyring.
- `dotfiles-operations`: ofrece simulación, confirmación, resumen y operaciones idempotentes en español.
- `documentation-site`: mantiene la documentación Markdown y su publicación estática en GitHub Pages.

### Modified Capabilities

- Ninguna; el proyecto aún no define capacidades duraderas.

## Impact

- Nuevo bootstrap, catálogos base, configuración mínima de Dotbot, integración Vaultwarden y pruebas sin modificar equipos reales.
- DNF, Homebrew, Flatpak y fuentes externas explícitamente declaradas; el catálogo de aplicaciones, fuentes tipográficas y servicios se difieren.
- GNOME, extensiones, atajos, Zsh avanzado, starship, plugins y configuraciones de aplicaciones quedan fuera de esta iteración.
