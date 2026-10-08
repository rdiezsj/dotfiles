# Tasks

## 1. Base de la actualización segura

- [x] 1.1 Crear el script Bash de mantenimiento con validación del checkout desplegado, comprobación de árbol limpio, `fetch` y avance rápido de la referencia configurada; verificarlo con pruebas unitarias que cubran checkout conforme, cambios locales y divergencia.
- [x] 1.2 Integrar Dotbot en modo no interactivo para actualizar enlaces gestionados después de sincronizar y conservar los destinos no gestionados; verificar con una prueba que actualice un enlace gestionado y otra que registre un conflicto sin sobrescribirlo.
- [x] 1.3 Añadir el alias Zsh `update` que invoque el script desde `~/.dotfiles`; verificar su declaración y que el script sea ejecutable y tenga sintaxis Bash válida.
- [x] 1.4 Documentar el uso del alias, los privilegios de `sudo`, los gestores cubiertos y la política de no sobrescritura; verificar los enlaces y comandos documentados con `tests/unit/documentacion.sh`.

## 2. Actualización de gestores declarados

- [x] 2.1 Implementar la fase DNF no interactiva que actualice metadatos, repositorios y paquetes, detecte un reinicio recomendado y lo incorpore al resumen sin reiniciar; verificarla con stubs de DNF y de detección de reinicio.
- [x] 2.2 Implementar las fases Homebrew y Flatpak de usuario sin confirmación, con resultado independiente por gestor; verificar comandos y manejo de fallo parcial mediante pruebas unitarias con stubs.
- [x] 2.3 Extender el catálogo de AppImage con una fuente oficial de versión y suma verificables, e implementar la sustitución atómica solo de los AppImage declarados; verificar una actualización válida y el rechazo de metadatos o suma no verificables.
- [x] 2.4 Implementar la actualización de las extensiones GNOME declaradas, manteniendo las RPM bajo DNF y validando compatibilidad/origen para las de extensions.gnome.org; verificar actualización compatible y conservación de una versión no compatible.

## 3. Resumen e integración

- [x] 3.1 Unificar los resultados de sincronización, Dotbot y cada gestor en un resumen en español con actualizados, conformes, omitidos y fallidos; verificar que un fallo parcial conserva las fases independientes y devuelve estado no nulo.
- [x] 3.2 Incluir el nuevo script en las comprobaciones de sintaxis y ejecutar `bash tests/unit/run.sh`, `bash tests/unit/documentacion.sh` y `openspec validate automate-system-updates --type change --strict`; corregir cualquier fallo atribuible al cambio.
