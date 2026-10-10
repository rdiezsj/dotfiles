# Tasks

## 1. Diagnóstico local

- [x] 1.1 Implementar `bin/dotfiles doctor` y el diagnóstico de enlaces, identidad, perfiles Sheldon y Ptyxis con salida y códigos definidos; verificar con pruebas aisladas de estado conforme, deriva, diagnóstico parcial, argumentos y fallos independientes.
- [x] 1.2 Verificar privacidad y ausencia de efectos secundarios con valores privados sintéticos, comandos vigilados y comparación de archivos, enlaces, permisos y fechas antes y después de ejecuciones repetidas.
- [x] 1.3 Documentar uso, alcance, códigos y orientación manual en `docs/automatizacion.md` y README; retirar la entrada de doctor de la hoja de ruta y ajustar la comprobación documental, verificando `tests/unit/documentacion.sh`.

- [x] 1.4 Añadir `dotfiles update` como acceso al mantenimiento existente y mantener el alias `update`; comprobar delegación, código de salida, independencia de Python y ausencia de ejecución con ayuda o argumentos inválidos en `tests/unit/dotfiles-cli.sh`, y documentar su uso.

## 2. Integración

- [x] 2.1 Ejecutar `bash scripts/check.sh`, comprobar sintaxis del lanzador y validar `add-dotfiles-doctor` con OpenSpec estricto; corregir fallos atribuibles al cambio y comprobar `git diff --check`.
