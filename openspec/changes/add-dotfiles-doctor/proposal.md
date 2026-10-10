# Proposal

## Why

El bootstrap aplica configuraciones, pero no hay un comando que compruebe después si los enlaces y el estado local siguen conformes. Necesitamos detectar deriva sin modificar la estación ni consultar secretos.

## What Changes

- Añadir `dotfiles doctor`, accesible desde Zsh y directamente con `./bin/dotfiles doctor`.
- Diagnosticar enlaces de `install.conf.yaml`, identidad Git global y permisos de su archivo local, perfiles Sheldon y valores aplicados de Ptyxis.
- Mostrar resultados en español con estados conforme, deriva y no comprobado; devolver 0, 1 o 2 respectivamente según el resumen.
- Añadir `dotfiles update` como acceso al mantenimiento existente, conservando el alias `update`.
- Mantener el diagnóstico sin escrituras, red, sudo, instalaciones ni consultas a Bitwarden.
- Documentar el alcance y retirar esta idea de la hoja de ruta.

## Capabilities

### New Capabilities

- `configuration-diagnostics`: Diagnóstico de solo lectura de la configuración gestionada y del estado local necesario para su uso.

### Modified Capabilities

- `dotfiles-operations`: Acceso al mantenimiento existente mediante `dotfiles update`, sin modificar su comportamiento.

## Impact

Nuevo lanzador `bin/dotfiles` y diagnóstico en `scripts/doctor.py`, PATH Zsh existente, pruebas aisladas y documentación. Se reutiliza PyYAML del submódulo Dotbot y Python 3, ya utilizados por el proyecto; no se añaden dependencias externas. No se reparan diferencias automáticamente ni se inventaría todo el software instalado.
