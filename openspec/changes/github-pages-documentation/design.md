# Design

## Context

El repositorio ya contiene `mkdocs.yml` con el tema Material y las fuentes
Markdown en `docs/`, pero no define un flujo de despliegue ni enlaza el
catálogo Fedora en la navegación. Ver `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**

- Publicar el sitio desde Markdown mediante GitHub Pages y GitHub Actions.
- Validar localmente la construcción antes de que llegue al flujo remoto.
- Mantener una navegación concisa que incluya las guías existentes.

**Non-Goals:**

- No generar ni versionar HTML construido.
- No desplegar mediante credenciales personales ni modificar la configuración
  del repositorio en GitHub.
- No cambiar el contenido funcional del bootstrap.

## Decisions

### Despliegue oficial de GitHub Pages

El flujo usará las acciones oficiales de configuración, carga y despliegue de
GitHub Pages, con permisos mínimos de `pages: write` e `id-token: write`.
Se activará al cambiar documentación o configuración en `main`, y manualmente.
Se descarta publicar con una rama `gh-pages` porque añade estado Git generado.

### Entorno de construcción fijado por dependencias Python

Se declarará un fichero de requisitos dedicado a la documentación con MkDocs
Material. El flujo y la comprobación local instalarán ese mismo fichero. Se
descarta depender de una instalación global porque no es reproducible.

### Comprobación local integrada

`scripts/check.sh` invocará una prueba que valide navegación y ejecute
`mkdocs build --strict` cuando la dependencia esté disponible. Si no lo está,
la prueba informará de la acción concreta para instalar las dependencias, sin
alterar el equipo.

## Risks / Trade-offs

- [GitHub Pages no activado en el repositorio] → El flujo queda preparado, pero
  una persona debe seleccionar GitHub Actions como origen de publicación.
- [Enlaces Markdown inválidos] → `mkdocs build --strict` bloquea la publicación.
- [Actualización de MkDocs Material] → La versión queda fijada y se actualiza
  explícitamente en un cambio posterior.

## Migration Plan

1. Añadir dependencias, navegación y flujo de publicación.
2. Ejecutar la validación local del sitio y las comprobaciones existentes.
3. Activar GitHub Pages desde Actions en el repositorio y comprobar el primer
   despliegue.

Para revertir, se elimina el flujo de GitHub Pages y el sitio deja de
publicarse; las fuentes Markdown permanecen intactas.
