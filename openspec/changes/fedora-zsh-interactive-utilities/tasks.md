## 1. Catálogo y configuración de Sheldon

- [x] 1.1 Añadir Sheldon al catálogo Homebrew y retirar la fórmula duplicada de plugins Zsh; verificar con la prueba unitaria del catálogo que las entradas sean idempotentes y no incluyan `tldr` ni fórmulas duplicadas.
- [x] 1.2 Crear la configuración TOML de Sheldon con SHA fijados para completions, autosuggestions, autopair, syntax highlighting, `sudo` y `extract`; verificar que `sheldon lock` y `sheldon source` terminan correctamente en estado local.
- [x] 1.3 Enlazar configuración mediante Dotbot, excluir los lockfiles y caché locales y adaptar el bootstrap para instalar Sheldon, materializar sus revisiones y registrar fallos; verificar simulación, conflicto y segunda ejecución sin cambios.

## 2. Integración de Zsh

- [x] 2.1 Sustituir las cargas directas de plugins en `.zshrc` por `sheldon source`, manteniendo fzf, Starship, historial y el guardado de shell interactiva; verificar con `zsh -n` y una shell no interactiva sin salida de plugins.
- [x] 2.2 Documentar la actualización de SHA, revisión del diff y regeneración del estado local; verificar que la documentación no instruye a actualizar plugins en cada arranque.

## 3. Utilidades de archivos

- [x] 3.1 Implementar `extract` con detección de tar/zip/7z, destino seguro y protección frente a sobrescritura; verificar formatos válidos, entrada inexistente y formato no compatible mediante pruebas unitarias.
- [x] 3.2 Implementar `compress` con asistente Gum y fallback Bash, formatos tar.gz/tar.xz/zip/7z, destino, división por bloques y confirmación de salidas existentes; verificar creación, rechazo de sobrescritura y conservación de originales en un directorio temporal.
- [x] 3.3 Mostrar el comando de recomposición para archivos divididos y documentar el flujo `cat` más `extract`; verificar que las partes recomponen un archivo que se puede extraer.

## 4. Pruebas y documentación

- [x] 4.1 Añadir pruebas unitarias para el catálogo, la configuración de Sheldon y las utilidades sin modificar el equipo real; verificar `./scripts/check.sh`, `zsh -n` y `git diff --check`.
- [x] 4.2 Actualizar README y documentación Fedora con instalación, mantenimiento, rutas versionadas, caché local excluida y ejemplos de `extract`/`compress`; verificar enlaces y comandos mediante revisión estática.
