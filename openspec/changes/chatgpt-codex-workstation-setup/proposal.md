# Proposal

## Why

La estación Fedora no instala la aplicación de escritorio de ChatGPT, que ahora ofrece Codex en Linux, ni OpenSpec como herramienta global declarada por el catálogo. Además, las instrucciones y skills globales de Codex están fuera del repositorio, por lo que no se reproducen al configurar otra cuenta o equipo.

## What Changes

- Instalar ChatGPT desde el RPM oficial de OpenAI en las versiones Fedora y arquitecturas que OpenAI admita.
- Añadir OpenSpec al catálogo de herramientas globales Homebrew, sin instalarlo como dependencia de un proyecto.
- Versionar `~/.codex/AGENTS.md` y el contenido completo de `~/.codex/skills/`, incluidos archivos ocultos y `.system/`, y enlazarlos desde Dotbot.
- Gestionar con confirmación y copia de respaldo los destinos Codex locales que ya existan y no estén enlazados a estos dotfiles.

## Capabilities

### New Capabilities

- `codex-user-configuration`: conserva y despliega las instrucciones globales `AGENTS.md` y todas las skills de usuario de Codex.

### Modified Capabilities

- `fedora-software-catalog`: instala ChatGPT desde el RPM oficial de OpenAI y OpenSpec como CLI global administrada por Homebrew.

## Impact

- Catálogos y lógica de instalación Fedora, detección de arquitectura y RPM oficial de OpenAI.
- `install.conf.yaml`, `home/.codex/` y gestión de conflictos de Dotbot.
- Pruebas unitarias de instalación idempotente, selección de arquitectura, enlaces de Codex y preservación ante conflictos.
- Dependencia global Homebrew `openspec`; ChatGPT se mantiene en el gestor DNF/RPM oficial. No se añaden credenciales ni estado local de Codex.
