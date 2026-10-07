# Proposal

## Why

La estación Fedora debe instalar y activar un conjunto esencial de extensiones
GNOME sin depender de clones Git ni compilación local. La gestión necesita un
bloque propio, visible en el bootstrap y documentado junto a los demás
componentes instalados.

## What Changes

- Instalar desde DNF AppIndicator y Dash to Dock, junto con las dependencias
  Fedora necesarias para Vitals.
- Instalar desde extensions.gnome.org las versiones compatibles de Custom Hot
  Corners Extended, Clipboard Indicator y Vitals, sin usar repositorios Git ni
  COPR.
- Activar idempotentemente las cinco extensiones para la persona que ejecuta
  el bootstrap, sin versionar sus preferencias ni alterar otras extensiones.
- Añadir un bloque independiente «Extensiones GNOME» al bootstrap, sus pruebas
  y la documentación del catálogo con origen, UUID, finalidad y estado local.

## Capabilities

### New Capabilities

- `gnome-extension-management`: instala y activa el conjunto declarado de
  extensiones GNOME desde las fuentes aprobadas para la sesión de usuario.

### Modified Capabilities

- `fedora-software-catalog`: añade los paquetes DNF que sustentan las
  extensiones declaradas.

## Impact

- Catálogo DNF y ejecutor del bootstrap Fedora.
- Pruebas unitarias de catálogos y de la instalación/activación de extensiones.
- `bootstrap` y `docs/catalogo-fedora.md`.
- Estado local de extensiones GNOME, que no se versiona.
