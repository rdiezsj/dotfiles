# Proposal

## Why

La configuración Zsh actual ya integra fzf y Starship, pero todavía no ofrece las autosugerencias, autopair, resaltado de sintaxis ni utilidades de compresión que forman parte del flujo diario. Sheldon permite gestionar plugins Git con referencias fijadas y un lockfile, manteniendo el arranque reproducible sin depender de Oh My Zsh ni zgen.

## What Changes

- Instalar Sheldon mediante Homebrew y versionar su configuración con revisiones Git fijadas, sin versionar sus lockfiles ni su caché local dependientes del equipo.
- Gestionar con Sheldon todos los plugins Zsh declarados: completions, autosuggestions, autopair y syntax highlighting, además de las capacidades `sudo` y `extract`; `compress` será una utilidad local.
- Mantener fzf y las integraciones nativas de kubectl fuera del gestor de plugins porque ya las proporcionan sus propias herramientas.
- Añadir `compress` como asistente Gum sencillo para formato, división por bloques y opciones compatibles; `extract` seguirá siendo una función directa.
- Completar la experiencia interactiva con `DOTFILES`, rutas de usuario deduplicadas, el aspecto de fzf y completado explícito de kubectl.
- Ofrecer abrir una sesión Zsh de inicio de sesión como último paso tras un bootstrap correcto.
- Integrar la inicialización y actualización controlada de plugins en el bootstrap, con modo simulación, idempotencia y resumen.
- Documentar cómo actualizar referencias, regenerar el estado local de Sheldon y recomponer archivos divididos.

## Capabilities

### New Capabilities

- `zsh-plugin-management`: Gestiona plugins Zsh declarativos, fijados y reproducibles mediante Sheldon.
- `archive-utilities`: Ofrece extracción directa y compresión interactiva de archivos y carpetas con Gum.

### Modified Capabilities

- `package-sources`: Añade Sheldon como herramienta Homebrew esencial para la terminal y separa sus plugins de las fórmulas de aplicaciones.

## Impact

- Afecta `catalogs/homebrew.sh`, la configuración versionada de Zsh, el bootstrap, las pruebas unitarias y la documentación.
- Añade Sheldon como dependencia Homebrew y repositorios Git externos fijados mediante SHA públicos.
- Escribe archivos de salida de compresión solo bajo rutas elegidas por la persona usuaria y no elimina originales.
- No almacena secretos, historial, cachés de Sheldon ni configuraciones específicas de un equipo.
