# Proposal

## Why

La barra de título de Terminator no respeta la apariencia oscura del escritorio y contrasta con el resto de la sesión. La comprobación manual con `GTK_THEME=Adwaita:dark terminator` confirma que el tema por aplicación resuelve el problema sin cambiar otras aplicaciones GTK.

## What Changes

- Añadir un lanzador de usuario para que `terminator` desde la terminal inicie la aplicación con `Adwaita:dark`.
- Añadir una entrada de escritorio de usuario que sustituya la del paquete para que el lanzador de GNOME aplique el mismo tema.
- Gestionar ambos archivos mediante Dotbot y documentar su alcance y la activación tras cerrar las ventanas existentes de Terminator.
- Añadir comprobaciones automatizadas de los nuevos archivos y sus enlaces.

## Capabilities

### New Capabilities

- Ninguna.

### Modified Capabilities

- `application-configuration`: Las configuraciones portables de aplicaciones incluirán el lanzador y la entrada de escritorio de Terminator para aplicar su tema de forma aislada.

## Impact

Se modifican los archivos gestionados en `home/.local/`, el inventario de destinos de Dotbot, las pruebas unitarias y la documentación de aplicaciones Fedora. No se añaden paquetes ni se cambia la configuración GTK global.
