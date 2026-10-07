# Design

## Context

`bootstrap` se ejecuta con Bash aunque se invoque desde una terminal Zsh, por
lo que la shell del intérprete del script no identifica la shell interactiva de
origen. Véanse `proposal.md` y la delta de `zsh-terminal-environment`.

## Goals / Non-Goals

**Goals:**

- Omitir el aviso redundante cuando el proceso padre inmediato del bootstrap
  sea Zsh.
- Mantener el aviso existente para Bash, otras shells y entornos no
  identificables.

**Non-Goals:**

- Cambiar la shell predeterminada, modificar `chsh` o abrir/cerrar terminales.
- Inferir la shell desde `$SHELL`, que representa la preferencia de inicio y
  no necesariamente la sesión que invocó el script.

## Decisions

### Detección del proceso padre

El ejecutor consultará el nombre del proceso padre inmediato y lo comparará con
Zsh. Se descarta `$SHELL` porque puede indicar Zsh aun cuando el bootstrap se
ejecute desde Bash, y se descarta el intérprete propio porque siempre es Bash.

### Fallback conservador

Si no puede identificarse el proceso padre, se conserva el aviso. Así no se
oculta la única oportunidad automática de cargar la configuración en una nueva
sesión Zsh.

## Risks / Trade-offs

- Un lanzador intermedio puede ocultar Zsh como proceso padre → se mostrará el
  aviso, que es preferible a omitir una recarga necesaria.
- El nombre del proceso puede variar por ruta o sufijo → la comparación usará
  el nombre base del ejecutable y tendrá pruebas con dobles de `ps`.

## Migration Plan

1. Actualizar el checkout de destino.
2. Ejecutar el bootstrap desde Zsh y comprobar que no aparece el aviso.
3. Ejecutarlo desde Bash y comprobar que el aviso se conserva.
