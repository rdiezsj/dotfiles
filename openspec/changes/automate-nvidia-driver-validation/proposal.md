# Proposal

## Why

El bootstrap instala actualmente la pila NVIDIA, pero deja la compilación de
akmods y la comprobación con `nvidia-smi` como acciones manuales. Tampoco
distingue una instalación ya conforme de una que necesita reparación, por lo
que no puede confirmar que el controlador propietario esté realmente operativo.

## What Changes

- Verificar la compatibilidad de la GPU NVIDIA detectada antes de gestionar el
  controlador propietario distribuido por RPM Fusion.
- Comprobar paquetes, módulo para el kernel activo, servicio de compilación
  akmods y disponibilidad de `nvidia-smi` antes de instalar o reparar nada.
- Esperar de forma acotada a la compilación de akmods y validar automáticamente
  el resultado durante cada ejecución manual del bootstrap; si requiere
  reinicio, indicar que la persona debe reiniciar y volver a ejecutar
  manualmente `./bootstrap`.
- Hacer idempotente la fase NVIDIA y reflejar estados verificables en el
  resumen final.
- Actualizar la documentación y el resumen final, conservando sus cambios
  existentes, para explicar el reinicio y la reejecución manuales y la única
  intervención inevitable de Secure Boot.

## Capabilities

### New Capabilities

<!-- None. -->

### Modified Capabilities

- `fedora-multimedia-nvidia`: seleccionar y validar de forma automática el
  controlador propietario RPM Fusion para hardware NVIDIA compatible.
- `dotfiles-operations`: informar resultados NVIDIA comprobados y un reinicio
  pendiente que se verifica en la siguiente ejecución, sin reinstalaciones.

## Impact

- Afecta `platforms/fedora/multimedia-nvidia.sh`, la fase NVIDIA de `bootstrap`,
  sus pruebas unitarias y la documentación de instalación y catálogo.
- Añade comprobaciones locales de RPM, akmods, módulo del kernel y
  `nvidia-smi`; no añade repositorios, controladores `.run` de NVIDIA ni
  reinicios automáticos.
