# Tasks

## 1. Catálogo y validación de herramientas

- [x] 1.1 Declarar `ptyxis` y `dconf` en `catalogs/dnf-rpm.sh`, y `zellij` en `catalogs/homebrew.sh`, conservando `terminator`, y verificar que `tests/unit/catalogos.sh` confirma cada inventario.
- [x] 1.2 Añadir a cada fase de catálogo la comprobación explícita de Ptyxis o Zellij tras su instalación o detección, y verificar los casos instalado, ya presente y fallo en `tests/unit/catalogo-software.sh`.
- [x] 1.3 Documentar Ptyxis, Zellij desde Homebrew y el papel alternativo de Terminator en `docs/catalogo-fedora.md`, y verificarlo con `tests/unit/documentacion.sh`.

## 2. Configuraciones gestionadas

- [x] 2.1 Crear la exportación Dconf limitada de Ptyxis con perfil Nord oscuro, UUID estable y scrollback sin límite bajo `home/.config/ptyxis/`, y verificar que solo contiene rutas y claves de `/org/gnome/Ptyxis/` sin datos de sesión ni preferencias ajenas.
- [x] 2.2 Crear el directorio `home/.config/zellij/` con un `config.kdl` inicial sin `keybinds`, autoarranque, plugins ni layouts personalizados, y verificar con `zellij setup --check` sobre una copia temporal para no alterar el directorio versionado.
- [x] 2.3 Declarar el archivo de Ptyxis y el directorio de Zellij en `install.conf.yaml` y en la detección de conflictos Dotbot, y verificar en `tests/unit/configuraciones-aplicaciones.sh` y `tests/unit/zsh-terminal.sh` que se enlazan y que un destino no gestionado genera respaldo recuperable.
- [x] 2.4 Aplicar la exportación Dconf de Ptyxis después de Dotbot y validar sus claves, incluida la paleta Nord y el scrollback ilimitado, sin escribir fuera de `/org/gnome/Ptyxis/`; verificar los casos conforme y fallido en una prueba unitaria aislada.
- [x] 2.5 Documentar en `docs/aplicaciones.md` el archivo enlazado de Ptyxis, el perfil reproducible y el uso manual de Zellij con `Ctrl+P`, `D` y `R`; verificar las nuevas referencias en `tests/unit/documentacion.sh`.

## 3. Verificación integrada

- [x] 3.1 Ejecutar `tests/unit/run.sh` y `openspec validate configure-ptyxis-zellij --strict`; corregir cualquier fallo atribuible al cambio.
- [ ] 3.2 En una estación Fedora de destino, ejecutar el bootstrap y comprobar manualmente que Terminator sigue disponible, Ptyxis abre con Nord y Zellij divide con `Ctrl+P`, `D` y `R` sin autoarrancarse.
