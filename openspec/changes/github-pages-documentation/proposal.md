# Proposal

## Why

La documentación ya tiene fuente Markdown y configuración MkDocs Material, pero
no existe un flujo que construya y publique el sitio en GitHub Pages. Además,
la página de inicio no orienta el recorrido, el README concentra materias
distintas y el catálogo no permite identificar con rapidez cada aplicación, su
finalidad, su gestor ni el tratamiento de su configuración.

## What Changes

- Añadir un flujo de GitHub Actions con permisos mínimos para construir y
  desplegar MkDocs Material en GitHub Pages tras cambios en la documentación.
- Completar la navegación del sitio con la guía del catálogo Fedora.
- Reorganizar la documentación para separar instalación, catálogo de software,
  configuración de aplicaciones, shell y seguridad; el README quedará como
  entrada breve que remite a las guías canónicas.
- Documentar el catálogo por tipo de paquetería y, para cada aplicación,
  explicar su finalidad, la configuración versionada —si existe— y los datos o
  estado locales que se excluyen del repositorio.
- Añadir comprobaciones locales reproducibles para validar la configuración y
  construcción del sitio antes de publicar.
- Documentar la activación única de GitHub Pages desde Actions en el repositorio
  público.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `documentation-site`: publicar de forma automatizada el sitio MkDocs Material
  existente y mantener su navegación y validación.

## Impact

- Afecta a `README.md`, `mkdocs.yml`, `docs/`, el flujo de GitHub Actions y las
  pruebas de validación del repositorio.
- Añade la dependencia de desarrollo reproducible de MkDocs Material para la
  construcción de documentación; no modifica el bootstrap de Fedora.
