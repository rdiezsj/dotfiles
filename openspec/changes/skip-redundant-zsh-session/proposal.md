# Proposal

## Why

El bootstrap ofrece abrir una sesión Zsh nueva al finalizar aunque se haya
ejecutado desde una terminal Zsh. Ese aviso es redundante y puede inducir a
abrir una shell anidada sin aportar ningún cambio de entorno.

## What Changes

- Detectar la shell interactiva que lanzó el bootstrap, diferenciándola del
  intérprete Bash del propio script.
- Omitir el aviso y la apertura de una nueva sesión cuando la terminal de
  origen ya sea Zsh.
- Mantener el comportamiento actual cuando la terminal de origen no sea Zsh o
  no se pueda identificar.
- Añadir pruebas unitarias para ambos recorridos y documentar el criterio de
  comportamiento de la sesión.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `zsh-terminal-environment`: el cierre del bootstrap evita proponer una nueva
  sesión Zsh si la terminal que lo invocó ya usa Zsh.

## Impact

- `scripts/lib/zsh-terminal.sh` y su prueba unitaria.
- Documentación de la terminal Zsh.
- No cambia la shell predeterminada ni ejecuta `chsh`.
