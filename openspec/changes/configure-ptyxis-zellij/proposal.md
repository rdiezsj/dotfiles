# Proposal

## Why

La estación Fedora necesita que Ptyxis sea la terminal principal con una
apariencia y preferencias equivalentes al perfil Nord de Terminator, y que
Zellij aporte paneles persistentes sin alterar los atajos nativos de este.
Terminator seguirá disponible y sin cambios como alternativa.

## What Changes

- Declarar Ptyxis y `dconf` en el catálogo DNF, y Zellij en Homebrew; comprobar
  ambos binarios tras su instalación, sin retirar Terminator.
- Versionar una exportación limitada de Dconf para Ptyxis y enlazarla mediante
  Dotbot; el bootstrap la aplicará bajo `/org/gnome/Ptyxis/` para crear un
  perfil Nord reproducible, oscuro y con scrollback sin límite.
- Versionar y enlazar `~/.config/zellij/config.kdl` mediante Dotbot.
- Configurar Zellij sin autoarranque y conservando sus combinaciones nativas:
  el modo de paneles sigue comenzando con `Ctrl+P`, incluido `D` y `R` para
  dividir.
- Ampliar pruebas y documentación para cubrir las nuevas configuraciones y su
  validación en una estación destino.

## Capabilities

### New Capabilities

- Ninguna.

### Modified Capabilities

- `application-configuration`: Las configuraciones portables incluirán los
  archivos de Ptyxis y Zellij gestionados por Dotbot, sin incluir estado local
  ni modificar la configuración existente de Terminator.
- `fedora-software-catalog`: DNF instalará Ptyxis junto a Terminator y
  Homebrew instalará Zellij; cada gestor validará su herramienta al terminar.

## Impact

Se modificarán los catálogos DNF y Homebrew, la fase de configuración posterior
a Dotbot, los destinos gestionados, pruebas unitarias y documentación. Se añadirán
archivos bajo `home/.config/ptyxis/` y `home/.config/zellij/`. No se
desinstalará Terminator, no se activará Zellij al iniciar la shell ni se
versionará la base Dconf completa del usuario.
