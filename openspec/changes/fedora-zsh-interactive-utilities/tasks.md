## 1. Catálogo y configuración de Sheldon

- [ ] 1.1 Añadir Sheldon al catálogo Homebrew y retirar la fórmula duplicada de plugins Zsh; verificar con la prueba unitaria del catálogo que las entradas sean idempotentes y no incluyan `tldr` ni fórmulas duplicadas.
- [ ] 1.2 Crear la configuración TOML de Sheldon y generar un lockfile con revisiones fijadas para completions, autosuggestions, autopair, syntax highlighting, `sudo` y `extract`; verificar que `sheldon lock` y `sheldon source` terminan correctamente.
- [ ] 1.3 Enlazar configuración y lockfile mediante Dotbot, excluir el caché local y adaptar el bootstrap para instalar Sheldon, validar el lockfile y registrar fallos; verificar simulación, conflicto y segunda ejecución sin cambios.

## 2. Integración de Zsh

- [ ] 2.1 Sustituir las cargas directas de plugins en `.zshrc` por `sheldon source`, manteniendo fzf, Starship, historial y el guardado de shell interactiva; verificar con `zsh -n` y una shell no interactiva sin salida de plugins.
- [ ] 2.2 Documentar `sheldon lock --update`, revisión del diff y regeneración del lockfile; verificar que la documentación no instruye a actualizar plugins en cada arranque.

## 3. Utilidades de archivos

- [ ] 3.1 Implementar `extract` con detección de tar/zip/7z, destino seguro y protección frente a sobrescritura; verificar formatos válidos, entrada inexistente y formato no compatible mediante pruebas unitarias.
- [ ] 3.2 Implementar `compress` con asistente Gum y fallback Bash, formatos tar.gz/tar.xz/zip/7z, destino, división por bloques y confirmación de salidas existentes; verificar creación, rechazo de sobrescritura y conservación de originales en un directorio temporal.
- [ ] 3.3 Mostrar el comando de recomposición para archivos divididos y documentar el flujo `cat` más `extract`; verificar que las partes recomponen un archivo que se puede extraer.

## 4. Pruebas y documentación

- [ ] 4.1 Añadir pruebas unitarias para el catálogo, la configuración de Sheldon y las utilidades sin modificar el equipo real; verificar `./scripts/check.sh`, `zsh -n` y `git diff --check`.
- [ ] 4.2 Actualizar README y documentación Fedora con instalación, mantenimiento, rutas versionadas, caché local excluida y ejemplos de `extract`/`compress`; verificar enlaces y comandos mediante revisión estática.
