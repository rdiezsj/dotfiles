# Proposal

## Why

La documentación ya tiene fuente Markdown y configuración MkDocs Material, pero
no existe un flujo que construya y publique el sitio en GitHub Pages. El
catálogo Fedora tampoco está incluido en la navegación pública.

## What Changes

- Añadir un flujo de GitHub Actions con permisos mínimos para construir y
  desplegar MkDocs Material en GitHub Pages tras cambios en la documentación.
- Completar la navegación del sitio con la guía del catálogo Fedora.
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

- Afecta a `mkdocs.yml`, `docs/`, el flujo de GitHub Actions y las pruebas de
  validación del repositorio.
- Añade la dependencia de desarrollo reproducible de MkDocs Material para la
  construcción de documentación; no modifica el bootstrap de Fedora.
