# Tasks

## 1. Catálogo Flatpak oficial

- [x] 1.1 Declarar `org.gnome.Extensions` y su finalidad en el catálogo Flatpak; verificar que `tests/unit/catalogos.sh` confirma el identificador y no introduce duplicados.
- [x] 1.2 Validar o corregir el remoto `flathub` de usuario para que use la URL oficial antes de instalar; verificar con dobles de `flatpak` los casos de remoto ausente, correcto y con URL distinta en `tests/unit/catalogo-software.sh`.
- [x] 1.3 Cubrir que GNOME Extensions se instala con `flatpak install --user -y flathub org.gnome.Extensions`; verificar con `tests/unit/catalogo-software.sh`.

## 2. Documentación y validación

- [x] 2.1 Documentar GNOME Extensions en el catálogo publicado de Flatpak; verificar con `tests/unit/documentacion.sh` y `mkdocs build --strict` cuando estén disponibles.
- [x] 2.2 Ejecutar la suite de verificación del proyecto y comprobar el cambio final con `bash tests/unit/run.sh`, `./scripts/check.sh` y `git diff --check`.
