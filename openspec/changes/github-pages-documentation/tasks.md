# Tasks

## 1. Fuentes y validación local del sitio

- [ ] 1.1 Declarar una dependencia Python fijada para MkDocs Material y ampliar `mkdocs.yml` con la navegación del catálogo Fedora; verificar que la configuración contiene todas las páginas Markdown publicadas.
- [ ] 1.2 Añadir una prueba de documentación que valide navegación, enlaces locales y ejecute `mkdocs build --strict` cuando MkDocs esté disponible; integrarla en `scripts/check.sh` y verificar que la suite sigue siendo ejecutable sin instalar dependencias de publicación.
- [ ] 1.3 Documentar en el README el procedimiento local de construcción y la activación única de GitHub Pages mediante GitHub Actions; verificar que las rutas y comandos coinciden con los archivos declarados.

## 2. Publicación con GitHub Pages

- [ ] 2.1 Añadir el flujo de GitHub Actions con construcción reproducible, carga y despliegue oficial de GitHub Pages; verificar su sintaxis y que se activa en `main` solo para documentación, configuración de MkDocs y el propio flujo, además de ejecución manual.
- [ ] 2.2 Ejecutar `./scripts/check.sh`, `git diff --check` y `openspec validate github-pages-documentation --strict`; registrar la primera publicación real en GitHub como validación manual pendiente.
