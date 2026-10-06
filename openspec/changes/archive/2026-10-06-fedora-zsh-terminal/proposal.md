# Proposal

## Why

El bootstrap ya instala Zsh y Homebrew, pero la estación no obtiene todavía una terminal Zsh funcional ni las herramientas CLI acordadas. Esta fase convierte ese entorno en reproducible y versionable sin asumir ni reemplazar configuraciones personales existentes.

## What Changes

- Declarar e instalar mediante Homebrew Starship, `zsh-completions`, fzf, Helm, `kubernetes-cli` y kubectx, con comprobaciones idempotentes por fórmula.
- Versionar `.zshrc`, `.zsh_aliases`, `.profile`, `.zprofile` y `home/config/starship.toml`; Dotbot enlazará este último en `~/.config/starship.toml` mediante una migración con respaldo recuperable de destinos existentes.
- Activar Homebrew, historial, alias, completado de Zsh, fzf y Starship en nuevas sesiones Zsh.
- Ofrecer el cambio de shell predeterminada a Zsh exclusivamente tras una confirmación humana explícita; la negativa no hará fallar el bootstrap.
- Añadir un resumen y pruebas con dobles para fórmulas, enlaces, conflictos y la elección de `chsh`.

## Capabilities

### New Capabilities
- `zsh-terminal-environment`: Proporciona una terminal Zsh versionada, con prompt, completado e integración de las herramientas CLI acordadas.

### Modified Capabilities
- `package-sources`: El catálogo Homebrew deja de estar solo declarado e instala de manera idempotente las fórmulas aprobadas para la terminal.

## Impact

- Afecta el catálogo `catalogs/homebrew.sh`, el bootstrap Fedora, la configuración Dotbot y los tests unitarios.
- Escribe únicamente archivos de configuración versionados y un respaldo fechado de los destinos sustituidos; no versiona secretos, contenido del historial, cachés ni preferencias específicas de equipo.
- El único cambio de cuenta es `chsh`; queda sujeto a confirmación explícita y no se ejecuta en simulación.
