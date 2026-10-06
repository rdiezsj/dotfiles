# Design

## Context

El repositorio ya contiene `mkdocs.yml` con el tema Material y las fuentes
Markdown en `docs/`, pero no define un flujo de despliegue ni una arquitectura
de información que permita recorrer la instalación y la operación sin leer un
README extenso. Ver `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**

- Publicar el sitio desde Markdown mediante GitHub Pages y GitHub Actions.
- Validar localmente la construcción antes de que llegue al flujo remoto.
- Mantener una navegación concisa, orientada a tareas y completa.
- Hacer trazable el software instalado, incluida su configuración versionada y
  el estado local excluido.

**Non-Goals:**

- No generar ni versionar HTML construido.
- No desplegar mediante credenciales personales ni modificar la configuración
  del repositorio en GitHub.
- No cambiar el contenido funcional del bootstrap ni el catálogo instalado.
- No documentar datos personales, valores de configuración de una máquina ni
  secretos.

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

### Documentación canónica por tarea

`docs/` será la fuente canónica del sitio: una portada guiará la instalación y
la validación; las guías especializadas separarán catálogo, aplicaciones,
terminal y seguridad. `README.md` conservará el propósito, el arranque rápido
y los enlaces a esas guías, sin duplicar procedimientos extensos. Se descarta
mantener toda la explicación en README porque dificulta descubrirla y revisar
sus enlaces en el sitio publicado.

### Catálogo agrupado por gestor

La guía de software agrupará DNF/RPM, Homebrew, Flatpak y AppImage. Cada
aplicación tendrá propósito, origen y una indicación explícita de si enlaza
configuración versionada o si sus datos, perfiles, cachés, sesiones, inventario
o rutas permanecen locales. Se descarta inferirlo desde los scripts porque la
documentación debe ser suficiente para tomar la decisión operativa.

### Comprobación local integrada

`scripts/check.sh` invocará una prueba que valide navegación y ejecute
`mkdocs build --strict` cuando la dependencia esté disponible. Si no lo está,
la prueba informará de la acción concreta para instalar las dependencias, sin
alterar el equipo.

## Risks / Trade-offs

- [GitHub Pages no activado en el repositorio] → El flujo queda preparado, pero
  una persona debe seleccionar GitHub Actions como origen de publicación.
- [Enlaces Markdown inválidos] → `mkdocs build --strict` bloquea la publicación.
- [Documentación desalineada del catálogo] → cada grupo de paquetería se
  contrastará con los catálogos y enlaces declarados antes de construir el
  sitio.
- [Actualización de MkDocs Material] → La versión queda fijada y se actualiza
  explícitamente en un cambio posterior.

## Migration Plan

1. Reorganizar las fuentes Markdown y añadir la navegación completa.
2. Añadir dependencias, validación local y flujo de publicación.
3. Ejecutar las comprobaciones existentes.
4. Activar GitHub Pages desde Actions en el repositorio y comprobar el primer
   despliegue.

Para revertir, se elimina el flujo de GitHub Pages y el sitio deja de
publicarse; las fuentes Markdown permanecen intactas.
