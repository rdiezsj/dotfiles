# Tasks

## 1. Detección de sesión Zsh

- [x] 1.1 Añadir a `scripts/lib/zsh-terminal.sh` la detección de la shell interactiva que invocó el bootstrap y omitir la solicitud de una sesión nueva si ya es Zsh; verificar con `tests/unit/zsh-terminal.sh` los casos Zsh, Bash y detección no disponible.
- [x] 1.2 Mantener la solicitud y la apertura de sesión existentes cuando el invocador no sea Zsh; verificar en `tests/unit/zsh-terminal.sh` que no cambia el comportamiento de confirmación aceptada o rechazada.
- [x] 1.3 Documentar en `docs/terminal.md` cuándo se ofrece una nueva sesión Zsh; verificar la presencia del criterio con `tests/unit/documentacion.sh`.

## 2. Validación de integración

- [x] 2.1 Ejecutar `bash tests/unit/run.sh`, `./scripts/check.sh`, `openspec validate skip-redundant-zsh-session --strict` y `git diff --check`.
