# Tasks

## 1. Arquitectura y contenido documental

- [x] 1.1 Reescribir la portada como recorrido de instalación, simulación y verificación, y reducir el README a entrada rápida con enlaces canónicos; verificar que ambos no duplican procedimientos extensos.
- [x] 1.2 Separar las guías de catálogo, configuración de aplicaciones, terminal y Vaultwarden; verificar que la navegación declarada contiene todas las páginas publicadas.
- [x] 1.3 Documentar el catálogo por DNF/RPM, Homebrew, Flatpak y AppImage, indicando por aplicación finalidad, origen, configuración versionada y estado local excluido; contrastar cada grupo con los catálogos declarados.

## 2. Construcción y validación local del sitio

- [x] 2.1 Declarar una dependencia Python fijada para MkDocs Material y ampliar `mkdocs.yml` con la navegación resultante; verificar que la configuración contiene todas las páginas Markdown publicadas.
- [x] 2.2 Añadir una prueba de documentación que valide navegación, enlaces locales y ejecute `mkdocs build --strict` cuando MkDocs esté disponible; integrarla en `scripts/check.sh` y verificar que la suite sigue siendo ejecutable sin instalar dependencias de publicación.
- [x] 2.3 Documentar el procedimiento local de construcción y la activación única de GitHub Pages mediante GitHub Actions; verificar que las rutas y comandos coinciden con los archivos declarados.

## 3. Publicación con GitHub Pages

- [x] 3.1 Añadir el flujo de GitHub Actions con construcción reproducible, carga y despliegue oficial de GitHub Pages; verificar su sintaxis y que se activa en `main` solo para documentación, configuración de MkDocs y el propio flujo, además de ejecución manual.
- [x] 3.2 Ejecutar `./scripts/check.sh`, `git diff --check` y `openspec validate github-pages-documentation --strict`; registrar la primera publicación real en GitHub como validación manual pendiente.
