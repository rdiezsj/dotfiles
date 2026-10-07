# Design

## Context

La configuración actual de Terminator solo controla sus perfiles internos; no controla la barra de título que GTK dibuja para la aplicación. La prueba manual con `GTK_THEME=Adwaita:dark terminator` confirma el resultado visual requerido. Dotbot ya protege los destinos locales no gestionados y puede enlazar archivos bajo `~/.local/`.

## Goals / Non-Goals

**Goals:**

- Aplicar el tema oscuro a Terminator desde el terminal del usuario y desde el lanzador de GNOME.
- Mantener el cambio portable mediante Dotbot y verificable con pruebas unitarias.
- Limitar el cambio de tema a Terminator.

**Non-Goals:**

- No cambiar el tema GTK global ni la configuración de otras aplicaciones.
- No modificar la barra de pestañas ni el perfil visual interno de Terminator.
- No instalar paquetes, compilar software ni ejecutar el bootstrap en el equipo de desarrollo.

## Decisions

### Lanzador de usuario y entrada de escritorio

Se versionará un ejecutable en `~/.local/bin/terminator` que exporta `GTK_THEME=Adwaita:dark` y delega en `/usr/bin/terminator`. Una entrada `~/.local/share/applications/terminator.desktop` con el mismo identificador que la del paquete iniciará el binario con la misma variable de entorno. Así se cubren los dos puntos de entrada del usuario sin depender de que el menú resuelva el `PATH` del shell.

Se descarta configurar `gtk-theme` globalmente porque afectaría a todas las aplicaciones GTK3. También se descarta editar la entrada de `/usr/share/applications`, ya que pertenece al paquete y una actualización la sobrescribiría.

### Entrada de escritorio completa

La entrada de usuario conservará los campos funcionales de la entrada distribuida por Terminator y cambiará solo los comandos de inicio. Su acceso heredado de nueva ventana se traducirá a una acción estándar de entrada de escritorio para que el override sea válido. Las entradas `.desktop` de usuario sustituyen la del sistema por identificador; no se fusionan, por lo que una copia mínima perdería metadatos y accesos directos del paquete.

## Risks / Trade-offs

- [Terminator ya está en ejecución] → Cerrar todas sus ventanas antes de la primera comprobación para que la nueva instancia reciba la variable de entorno.
- [El paquete cambia campos de su entrada] → Conservar los campos actuales y revisar la copia en una actualización relevante de Terminator.
- [Conflicto con un lanzador local] → Dejar que Dotbot lo detecte y lo conserve, como para el resto de configuraciones portables.

## Migration Plan

1. Aplicar Dotbot en una estación de destino; nunca en este equipo de desarrollo.
2. Cerrar cualquier instancia existente de Terminator y abrirla desde el menú o mediante `terminator`.
3. Para revertir, retirar los dos enlaces gestionados de `~/.local/`; la entrada y el binario del paquete seguirán disponibles.
