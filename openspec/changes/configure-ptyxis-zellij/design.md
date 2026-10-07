# Design

## Context

Terminator ya conserva un perfil Nord y es una aplicación gestionada por
Dotbot. Ptyxis almacena sus preferencias en Dconf, mientras que Zellij admite
un archivo KDL bajo XDG. El repositorio ya tiene un catálogo DNF, una lista
centralizada de destinos Dotbot y pruebas unitarias que validan esos destinos.

## Goals / Non-Goals

**Goals:**

- Añadir Ptyxis y Zellij sin cambiar la instalación ni los enlaces de
  Terminator.
- Hacer reproducible el perfil Ptyxis sin exportar la base Dconf completa.
- Mantener la experiencia estándar de Zellij, especialmente su modo de
  paneles con prefijo `Ctrl+P`.

**Non-Goals:**

- No desinstalar, alterar ni redirigir el lanzador de Terminator.
- No iniciar Zellij automáticamente desde Zsh ni preconfigurar plugins,
  layouts personalizados o atajos alternativos.
- No copiar todo el estado Dconf, sesiones de Ptyxis ni datos de Zellij.

## Decisions

### Exportación Dconf limitada y enlazada

Se versionará un archivo de texto Dconf bajo `home/.config/ptyxis/` y Dotbot
lo enlazará a `~/.config/ptyxis/`. Tras resolver sus conflictos, el bootstrap
lo cargará exclusivamente en `/org/gnome/Ptyxis/` y validará el perfil
resultante mediante `gsettings` o `dconf`. Esto permite que el contenido
versionado se vea y gestione como los demás dotfiles sin enlazar la base
binaria de Dconf.

Se descarta enlazar `~/.config/dconf/user`: contiene preferencias no
relacionadas y su formato binario no es portable. También se descarta dejar la
configuración manual: no sería reproducible en la estación destino.

La exportación declarará un UUID estable para un único perfil Ptyxis, la
paleta Nord integrada, interfaz oscura y scrollback sin límite. No incluirá
fuente, tamaño de ventana, restauración de sesión ni otras preferencias no
solicitadas.

### Zellij mínimo sin remapeos

Se versionará el directorio `home/.config/zellij/` y Dotbot lo enlazará como
`~/.config/zellij/`. Inicialmente contendrá solo `config.kdl`, que conservará
el modo de claves predeterminado de Zellij y no definirá `keybinds`, por lo que
`Ctrl+P`, `D` y `R` mantienen su significado nativo. El enlace de directorio
permite incorporar más adelante plugins u otros recursos de Zellij de forma
versionada. Tampoco se añadirá la invocación de Zellij a `.zshrc`, `.zprofile`
ni perfiles de Ptyxis.

Se descarta reproducir los atajos directos de Terminator porque sustituirían
el flujo estándar que se ha elegido conservar y podrían interferir con
aplicaciones ejecutadas dentro de los paneles.

### Paquetes y validación en el destino

Ptyxis y `dconf` se declararán en el catálogo DNF, junto a Terminator. Zellij
se declarará como fórmula Homebrew para que la herramienta de paneles tenga un
origen transversal y sencillo de mantener. Cada fase comprobará su binario
después de instalar o detectar el paquete o fórmula correspondiente. La
configuración de Ptyxis se aplicará solo después de que Dotbot haya enlazado el
archivo; Zellij se validará con su comprobación de configuración sin iniciar
una sesión interactiva.

## Risks / Trade-offs

- [Un UUID Dconf ya usado localmente] → El perfil gestionado usará un UUID
  exclusivo y la fase de aplicación documentará que actualiza solo ese perfil.
- [Una actualización de Ptyxis cambia claves o paletas] → Las pruebas
  comprobarán las claves necesarias y el bootstrap comunicará un fallo claro
  de validación.
- [Un archivo Zellij local no gestionado] → Dotbot conservará el mecanismo de
  conflicto y respaldo ya existente; no lo sustituirá sin confirmación.
- [La validación de Zellij requiere recursos de sesión] → Se ejecutará con un
  directorio temporal seguro para sus sockets y una copia de la configuración,
  que se limpiarán al finalizar sin alterar el directorio versionado.

## Migration Plan

1. Instalar Ptyxis y `dconf` desde DNF, y Zellij desde Homebrew, sin retirar
   Terminator.
2. Resolver posibles conflictos de Dotbot y enlazar las configuraciones
   versionadas.
3. Aplicar y validar la exportación limitada de Ptyxis; validar la sintaxis de
   Zellij.
4. Abrir Ptyxis y ejecutar Zellij manualmente para comprobar el perfil Nord y
   `Ctrl+P`, `D` y `R`.
5. Para revertir, retirar únicamente los enlaces y la aplicación Dconf del
   perfil gestionado; Terminator queda operativo durante toda la migración.
