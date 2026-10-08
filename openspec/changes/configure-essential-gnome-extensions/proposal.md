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
  el bootstrap; si una instalación recién confirmada aún no está disponible
  para activarse, registrarla como pendiente de una nueva sesión GNOME, sin
  versionar sus preferencias ni alterar otras extensiones.
- Añadir el alias `activar-extensiones-gnome` para completar y verificar solo
  la activación de las extensiones declaradas tras iniciar una nueva sesión,
  sin actualizar software ni modificar preferencias.
- Añadir un bloque independiente «Extensiones GNOME» al bootstrap, sus pruebas
  y la documentación del catálogo con origen, UUID, finalidad y estado local.

## Capabilities

### New Capabilities

- `gnome-extension-management`: instala y activa el conjunto declarado de
  extensiones GNOME desde las fuentes aprobadas, incluida la activación
  diferida y verificable para la sesión de usuario.

### Modified Capabilities

- `fedora-software-catalog`: añade los paquetes DNF que sustentan las
  extensiones declaradas.
- `zsh-terminal-environment`: añade el alias interactivo limitado a completar
  la activación de extensiones GNOME declaradas.

## Impact

- Catálogo DNF y ejecutor del bootstrap Fedora.
- Pruebas unitarias de catálogos y de la instalación/activación de extensiones.
- `bootstrap`, el alias de Zsh, un ejecutable de verificación y la
  documentación del catálogo.
- Estado local de extensiones GNOME, que no se versiona.
