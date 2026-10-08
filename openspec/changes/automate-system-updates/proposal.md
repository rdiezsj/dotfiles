# Proposal

## Why

La estación ya instala software y configuraciones desde varios gestores, pero
carece de un único mantenimiento periódico que actualice de forma coherente el
checkout desplegado, los enlaces de Dotbot y todos sus gestores. Ejecutar cada
paso manualmente deja actualizaciones pendientes y puede desalinear la
configuración local respecto al repositorio.

## What Changes

- Añadir un script de actualización no interactivo y un alias Zsh `update` para
  invocarlo.
- Sincronizar el checkout desplegado de dotfiles con su remoto y referencia
  configurada antes de aplicar configuraciones versionadas.
- Detectar y aplicar los cambios de configuración declarados mediante Dotbot.
- Actualizar sin confirmaciones DNF y sus metadatos/repositorios, Homebrew,
  Flatpak de usuario, los AppImage declarados y las extensiones GNOME
  gestionadas por el proyecto.
- Ofrecer un resumen por fase y un código de salida no satisfactorio si alguna
  fase falla, sin exponer secretos.
- Documentar qué gestores cubre el alias y sus límites: solo AppImage y
  extensiones GNOME declarados por el repositorio, no elementos locales que
  Gear Lever o GNOME no gestionen desde esta configuración.

## Capabilities

### New Capabilities

- `workstation-updates`: Mantiene de forma no interactiva el checkout y las
  fuentes de software gestionadas de una estación Fedora desplegada.

### Modified Capabilities

- Ninguna.

## Impact

- Nuevo script de mantenimiento y alias en `home/.zsh_aliases`.
- Posibles reutilizaciones acotadas de los catálogos, Dotbot y la gestión de
  extensiones GNOME existentes.
- Nuevas pruebas unitarias y documentación del flujo de actualización.
- Afecta una estación Fedora Workstation con GNOME y requiere las credenciales
  habituales de `sudo` cuando DNF o repositorios del sistema las necesiten.
