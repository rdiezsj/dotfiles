# Design: Sheldon y utilidades interactivas de Zsh

## Context

La configuración actual de Zsh carga directamente fzf y Starship, mientras que las capacidades solicitadas dependen de varios repositorios Git y de scripts que hasta ahora no están versionados. Oh My Zsh y zgen aportarían más framework del necesario. Sheldon ofrece una configuración TOML, referencias fijadas y un lockfile, y se instala con Homebrew ya presente en el bootstrap Fedora.

## Goals / Non-Goals

### Goals

- Centralizar la carga de plugins Zsh en Sheldon sin instalar Oh My Zsh completo.
- Versionar configuración y lockfile; mantener cachés y clones de trabajo fuera del repositorio.
- Cargar plugins en un orden seguro: completions, utilidades de edición, autosuggestions y syntax highlighting al final.
- Ofrecer `extract` directo y `compress` guiado por Gum, con salida segura y recomposición documentada.
- Mantener fzf, kubectl y Starship como integraciones de sus propias herramientas.

### Non-Goals

- Añadir Oh My Zsh, zgen u otro framework de temas.
- Actualizar plugins automáticamente en cada arranque.
- Implementar un gestor de archivos AppImage o sustituir GearLever.
- Crear compresión cifrada, borrado seguro de originales o un asistente con opciones específicas de cada formato más allá de lo esencial.

## Decisions

### Sheldon como fuente única de plugins

Sheldon se instalará mediante Homebrew. La configuración se enlazará desde una ruta versionada bajo `home/config/sheldon/` y el lockfile se versionará junto a ella. Se declararán repositorios de zsh-completions, zsh-autosuggestions, zsh-autopair, zsh-syntax-highlighting y los scripts `sudo` y `extract` de Oh My Zsh mediante selección de archivos, sin cargar el framework completo. La fórmula `zsh-completions` dejará de ser necesaria en el catálogo Homebrew para evitar dos fuentes de verdad.

### Bloqueo y mantenimiento

El bootstrap ejecutará `sheldon lock` para validar o crear el lockfile después de instalar Sheldon. Las actualizaciones usarán `sheldon lock --update` como acción explícita y se revisarán antes de hacer commit. El arranque ejecutará `sheldon source` contra el lockfile existente y no invocará la actualización automática.

### Orden de carga

La configuración cargará primero completions y funciones de edición, después autosuggestions y por último syntax highlighting. La inicialización quedará condicionada a una shell interactiva y a la existencia de Sheldon; si falta, se mostrará una advertencia breve sin romper shells no interactivas.

### Utilidad `extract`

Se implementará como función local versionada que valida una entrada única, identifica tar/zip/7z mediante herramientas disponibles y extrae en un directorio de destino derivado, sin eliminar originales ni sobrescribir sin confirmación.

### Utilidad `compress`

Será una función local versionada. En una terminal con Gum ofrecerá selección de formato (`tar.gz`, `tar.xz`, `zip`, `7z`), destino, tamaño de bloque y opciones sencillas. Construirá el archivo sin borrar entradas y rechazará salidas existentes salvo confirmación. La división se hará sobre el archivo terminado con `split`, y se mostrará el comando `cat` de recomposición; así se mantiene el comportamiento uniforme entre formatos.

## Risks / Trade-offs

- Los repositorios Git externos pueden cambiar de disponibilidad; el lockfile reduce el riesgo de cambios de contenido, pero una referencia inaccesible debe producir un fallo explícito.
- Cargar scripts aislados de Oh My Zsh reduce dependencias, pero exige comprobar en pruebas que no dependen de inicialización global del framework.
- Sheldon puede mantener datos bajo `~/.local/share/sheldon`; esa ruta será explícitamente local e ignorada y nunca se enlazará desde el repositorio.
- La división genérica con `split` requiere recomponer antes de extraer; el asistente y la documentación lo indicarán claramente.

## Migration Plan

1. Añadir Sheldon al catálogo Homebrew y retirar la fórmula duplicada de plugins Zsh.
2. Crear y enlazar `plugins.toml` y el lockfile; generar el lockfile en una máquina con red y revisar las revisiones antes de versionarlo.
3. Sustituir las cargas directas de plugins en `.zshrc` por `sheldon source`, conservando fzf, Starship y la configuración de historial.
4. Añadir `extract`, `compress`, pruebas unitarias y documentación de mantenimiento.
5. Ejecutar bootstrap en modo simulación y después en una Fedora limpia; verificar una segunda ejecución idempotente.

## Open Questions

No quedan decisiones de alcance abiertas para implementar esta propuesta. Las revisiones concretas del lockfile se resolverán durante la implementación al generar el bloqueo desde los repositorios declarados.
