# Proposal

## Why

Un conflicto de Dotbot puede impedir enlazar `plugins.toml` y dejar Sheldon sin
materializar, pero el bootstrap no muestra el conjunto de conflictos ni permite
elegir qué hacer con cada destino.

## What Changes

- Detectar todos los destinos no gestionados antes de ejecutar Dotbot.
- Mostrar por cada conflicto la ruta y el origen versionado, y pedir
  confirmación explícita antes de respaldar el original y aplicar el enlace.
- Aplicar solo las elecciones confirmadas y explicar en el resumen los
  conflictos omitidos y la causa concreta de una Sheldon no materializada.
- Documentar el flujo de resolución y el diagnóstico de Sheldon.

## Capabilities

### New Capabilities

<!-- None. -->

### Modified Capabilities

- `workstation-configuration`: resolución explícita y no destructiva de
  conflictos de enlaces Dotbot.
- `zsh-plugin-management`: diagnóstico accionable si no se enlaza la
  configuración o no se materializan los perfiles Sheldon.

## Impact

- Afecta las bibliotecas de configuración del bootstrap, pruebas unitarias y
  documentación Zsh.
- No aplica enlaces ni mueve configuraciones locales sin confirmación humana.
