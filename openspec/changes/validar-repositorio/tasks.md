# Tasks

## 1. Workflow de validación

- [x] 1.1 Crear `.github/workflows/validar-repositorio.yml` con el nombre visible `Validar repositorio`, permisos mínimos de lectura y ejecución en propuestas contra `main`, cambios en `main` y ejecución manual.
- [x] 1.2 Preparar el entorno efímero del workflow: checkout recursivo de submódulos, dependencias de documentación, `pre-commit` y Go compatible con Gitleaks; fijar las acciones externas a commits completos.
- [x] 1.3 Ejecutar `bash scripts/check.sh` como única barrera integrada del workflow y comprobar que sus fallos hacen fallar el job.

## 2. Estado visible y verificación

- [x] 2.1 Añadir al README el badge del workflow y ampliar `tests/unit/documentacion.sh` para exigirlo.
- [x] 2.2 Verificar el YAML con `actionlint`, ejecutar la validación integrada, `git diff --check` y `openspec validate validar-repositorio --strict`.

## 3. Documentación de automatización

- [x] 3.1 Crear la guía de automatización con finalidad, disparadores, límites y reproducción local de los workflows de validación, secretos y documentación.
- [x] 3.2 Enlazar la guía desde MkDocs y el README, ampliar la prueba documental y verificar la construcción estricta.
