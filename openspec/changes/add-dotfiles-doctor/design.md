# Design

## Context

`install.conf.yaml` declara enlaces a archivos y directorios. Zsh ya añade `~/.dotfiles/bin` al PATH. Dotbot incluye PyYAML como submódulo, y el bootstrap guarda la identidad fuera del repositorio, materializa dos perfiles Sheldon y aplica un archivo Dconf de Ptyxis. Véase la motivación en `proposal.md`.

## Goals / Non-Goals

**Goals:** Un comando local repetible, con comprobaciones independientes y estados distinguibles para uso manual y automatizado.

**Non-Goals:** Inventario exhaustivo de paquetes, validación de sesiones Bitwarden, comprobación remota de actualizaciones, reparación automática o ejecución del bootstrap. La identidad omitida voluntariamente se informa como deriva de una estación plenamente configurada; no se cambia su carácter opcional en bootstrap.

## Decisions

- Lanzador Bash `bin/dotfiles` que acepta `doctor`, `update` y ayuda, y llama a Python 3 con bytecode desactivado. El diagnóstico determina su checkout por la ubicación del código; `DOTFILES_HOME` permite elegir otro checkout como en el mantenimiento existente. La alternativa de un alias añade otra declaración innecesaria.
- Leer YAML mediante el PyYAML de Dotbot, sin instalaciones ni inicialización automática. El lector disponible en el checkout evita analizar YAML con expresiones regulares. Si falta o hay un formato no soportado, informar no comprobado y continuar con el resto.
- Evaluar enlaces con resolución canónica, incluyendo directorios, espacios y enlaces relativos. Un archivo local equivalente sigue siendo un destino ajeno porque no lo gestiona Dotbot. El destino se comprueba en HOME, como declara actualmente Dotbot, independientemente de XDG_CONFIG_HOME.
- Identidad: consultar únicamente Git global con includes, sin imprimir stdout ni stderr del comando. Comprobar permisos del archivo local cuando exista; no exigirlo si hay una identidad global completa por otro mecanismo. No leer ni mostrar datos de Vaultwarden.
- Sheldon: comprobar únicamente presencia de lockfiles no vacíos en `${XDG_DATA_HOME:-$HOME/.local/share}/sheldon`, no prometer validar revisiones ni cachés de plugins.
- Ptyxis: analizar el archivo versionado y comparar todas sus claves usando `dconf read /org/gnome/Ptyxis/...`. No ejecutar `dconf load` ni consultar esquemas con operaciones de escritura. Limitar cada proceso de consulta a cinco segundos y suprimir stderr potencialmente privado.
- Informe ASCII en español y contadores; 1 prevalece cuando hay deriva, 2 identifica un informe parcial sin deriva observada. Orientación manual por categoría, sin ofrecer un modo de reparación.

- `dotfiles update` delega con `exec` en `scripts/actualizar.sh` del mismo checkout. Conserva entorno y código de salida, sin depender de Python ni duplicar la lógica de mantenimiento. El alias `update` se mantiene. La ayuda y los argumentos inválidos no ejecutan operaciones.

## Risks / Trade-offs

- [Checkout sin submódulos] → informar diagnóstico parcial; la persona puede inicializarlos explícitamente fuera del doctor.
- [Estado local de Sheldon presente pero desactualizado] → documentar que se comprueba existencia, no su contenido ni revisión.
- [Equipo sin sesión GNOME o dconf] → distinguir consulta no disponible de un valor leído distinto.
- [Identidad intencionadamente omitida] → informar claramente y conservar el bootstrap opcional.
- [Cambios concurrentes mientras se lee] → el informe representa las lecturas realizadas; no se bloquean archivos ni procesos.

## Migration Plan

Distribuir por el flujo habitual de actualización de dotfiles. No requiere migración de datos ni cambios de permisos locales. Para revertir, retirar el lanzador y el diagnóstico; no hay estado creado por el comando.
