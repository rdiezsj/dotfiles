# Proposal

## Why

El catálogo Flatpak no declara GNOME Extensions, por lo que el bootstrap no
instala la aplicación solicitada aunque configure Flathub. La instalación debe
usar el identificador oficial de Flathub y conservar el origen oficial del
remoto de usuario.

## What Changes

- Declarar `org.gnome.Extensions` en el catálogo Flatpak con su descripción.
- Verificar que el remoto de usuario `flathub` usa la URL oficial antes de
  instalar aplicaciones del catálogo.
- Documentar GNOME Extensions como aplicación Flatpak y añadir pruebas de la
  declaración y de la ruta de instalación desde Flathub.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `fedora-software-catalog`: el catálogo de software Fedora incluirá GNOME
  Extensions desde Flathub y comprobará el origen del remoto usado.

## Impact

- `catalogs/flatpak.sh`
- `platforms/fedora/catalogo-software.sh`
- Pruebas unitarias de catálogo Flatpak.
- `docs/catalogo-fedora.md`
