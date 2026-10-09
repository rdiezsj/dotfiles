# Automatización

Los workflows de GitHub Actions tienen responsabilidades separadas: validar la
integridad técnica, detectar secretos y publicar la documentación. Ninguno
ejecuta el bootstrap ni modifica una estación Fedora.

## Validar repositorio

**Validar repositorio** se ejecuta al abrir o actualizar una propuesta contra
`main`, al integrar cambios en `main` y manualmente. Solo dispone de permisos
de lectura sobre el contenido del repositorio.

El workflow obtiene los submódulos, instala las dependencias de documentación,
`pre-commit` y Go, y ejecuta:

```bash
bash scripts/check.sh
```

Ese comando comprueba sintaxis Bash, pruebas unitarias y construcción estricta
de MkDocs. Para reproducirlo localmente, instala las dependencias de
documentación y `pre-commit` en un entorno aislado antes de ejecutar el mismo
comando. No sustituye las validaciones en una estación Fedora destino ni
ejecuta `./bootstrap` desde este checkout de desarrollo.

## Analizar secretos

**Analizar secretos** se ejecuta con los mismos disparadores: propuestas contra
`main`, cambios en `main` y ejecución manual. Usa Gitleaks sobre el historial
necesario para detectar secretos que se hubieran añadido y eliminado dentro de
la misma rama; no publica comentarios ni artefactos con hallazgos.

Para comprobarlo localmente:

```bash
pre-commit run --all-files
```

Consulta [Prevención de secretos](seguridad.md) para instalar el hook, actuar
ante una detección y registrar excepciones mínimas revisables.

## Publicar documentación

**Publicar documentación** se ejecuta manualmente o al incorporar en `main`
cambios en `docs/`, `README.md`, `mkdocs.yml`, `requirements-docs.txt` o su
propio workflow. Construye el sitio con `mkdocs build --strict` y lo despliega
en GitHub Pages. Es el único de los tres workflows con permisos de escritura
para Pages e identidad OIDC.

Para construir exactamente el contenido antes de publicarlo:

```bash
python3 -m venv /tmp/dotfiles-docs
/tmp/dotfiles-docs/bin/pip install -r requirements-docs.txt
/tmp/dotfiles-docs/bin/mkdocs build --strict
```

Una ejecución correcta construye y publica el sitio; no valida el bootstrap ni
reanuda otros workflows.
