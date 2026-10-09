# Design

## Context

La validación integrada ya está centralizada en `scripts/check.sh`, pero solo
se ejecuta localmente. El workflow de documentación publica Pages y el de
secretos analiza credenciales, sin ejecutar esta barrera completa. La propuesta
define el alcance funcional.

## Goals / Non-Goals

**Goals:**

- Ejecutar en GitHub Actions la misma validación integrada disponible
  localmente.
- Evitar resultados parcialmente verificados instalando las dependencias que
  permiten construir la documentación estricta y ejecutar el hook de secretos.
- Mantener un estado visible y diferenciable de publicación y seguridad.

**Non-Goals:**

- Ejecutar el bootstrap, DNF, Flatpak, Homebrew ni validaciones de una estación
  Fedora destino.
- Fusionar los workflows de publicación, seguridad y validación en uno solo.
- Añadir análisis estático adicional como ShellCheck en este cambio.
- Requerir la CLI de OpenSpec u otra herramienta de planificación para validar
  el repositorio.

## Decisions

- Crear `.github/workflows/validar-repositorio.yml`, con el nombre visible
  **Validar repositorio**. Es descriptivo y no confunde la verificación con la
  publicación ni la protección de secretos.
- Activarlo en `pull_request` contra `main`, `push` a `main` y
  `workflow_dispatch`. El mismo flujo cubre la propuesta antes de integrar y
  el resultado definitivo tras integrar.
- Usar un único job que invoque `bash scripts/check.sh`. La lógica no se
  duplicará en YAML: el script local seguirá siendo la fuente única de la
  validación y no invocará OpenSpec. OpenSpec puede seguir instalado y
  versionado como software de desarrollo, igual que otras aplicaciones del
  catálogo, sin ser una dependencia de CI.
- Obtener el checkout con submódulos recursivos, preparar Python con las
  dependencias de documentación, `pre-commit` y una versión de Go compatible
  con el hook de Gitleaks. Así `tests/unit/documentacion.sh` no omite MkDocs y
  `tests/unit/secret-exposure-prevention.sh` puede ejecutar el hook real.
- Dar al workflow solo `contents: read` y fijar las acciones externas a commits
  completos, siguiendo el patrón del workflow de secretos. Se descarta usar
  permisos de escritura porque el job no publica resultados ni comentarios.
- Añadir un badge de `validar-repositorio.yml` al README y extender la prueba
  documental para exigirlo.
- Crear una guía de automatización en MkDocs que diferencie validación,
  secretos y publicación, indique sus disparadores y límites, y use los mismos
  comandos locales que los workflows para su reproducción.

## Risks / Trade-offs

- [Descarga inicial de dependencias y Gitleaks] → Usar cachés gestionadas por
  los gestores y mantener un solo job para evitar duplicar instalaciones.
- [Fallos por cambios en el submódulo Dotbot] → Clonar submódulos de forma
  explícita antes de ejecutar la suite.
- [Diferencia entre entorno local y runner] → Ejecutar exactamente
  `scripts/check.sh` y conservar pruebas aisladas con dobles de comandos.
- [Cambio de una dependencia externa] → Fijar acciones y versiones declaradas
  y actualizar únicamente mediante un cambio revisable.

## Migration Plan

1. Añadir el workflow y el badge junto a pruebas que validen su estructura.
2. Añadir la guía de automatización, su navegación y sus comprobaciones
   documentales.
3. Verificar localmente la sintaxis del workflow y la suite integrada.
4. Mantener la validación independiente de OpenSpec u otra metodología de
   desarrollo.
5. Tras publicar, confirmar una ejecución correcta en GitHub Actions antes de
   exigirla como protección de rama.
