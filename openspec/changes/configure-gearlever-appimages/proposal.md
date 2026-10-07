# Proposal

## Why

El catálogo deja los AppImage verificados en `~/Apps`, pero Gear Lever conserva
por defecto otra carpeta y su preferencia esencial no se reproduce entre
estaciones. Además, al integrar un AppImage v2 Gear Lever detecta la ausencia
de FUSE en el host y no puede ejecutarlo.

## What Changes

- Versionar una declaración mínima de preferencias de Gear Lever y aplicarla
  durante el bootstrap una vez disponible su Flatpak, para que su carpeta
  predeterminada sea `$HOME/Apps`.
- Mantener fuera del control de versiones el sandbox de Gear Lever, los
  AppImage integrados, el inventario, las rutas por aplicación y el estado de
  actualizaciones.
- Declarar e instalar la compatibilidad FUSE requerida por AppImage v2 como
  parte del catálogo DNF, de forma idempotente.
- Versionar y enlazar los ficheros de preferencias creados manualmente para
  Heynote y Flameshot, y el directorio completo de Input Remapper 2 con sus
  presets declarados.
- Ampliar pruebas y documentación para verificar la preferencia aplicada y la
  dependencia de ejecución.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `application-configuration`: versionar las preferencias explícitamente
  elegidas de Gear Lever, Heynote, Flameshot e Input Remapper 2, preservando
  los datos locales no declarados.
- `fedora-software-catalog`: asegurar FUSE de compatibilidad para ejecutar los
  AppImage gestionados por Gear Lever.

## Impact

- `home/`, `install.conf.yaml` y la fase de bootstrap posterior al catálogo
  Flatpak, incluidos los enlaces de configuración de aplicación.
- Catálogo y ejecutor DNF en `catalogs/` y `platforms/fedora/`.
- Pruebas unitarias y documentación de instalación/catálogo.
