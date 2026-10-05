#!/usr/bin/env bash

# Catálogo DNF/RPM de la estación Fedora. Cada elemento se gestiona de forma
# idempotente y sus fuentes externas se validan antes de usarlo.
PAQUETES_DNF=(
  gnome-tweaks
  sushi
  p7zip
  p7zip-plugins
  file-roller
  vlc
  syncthing
  terminator
  vim-enhanced
  wl-clipboard
  pipx
  input-remapper
  code
  firefox
)

declare -gA DESCRIPCIONES_DNF=(
  [gnome-tweaks]='Ajustes adicionales para GNOME'
  [sushi]='Vista previa rápida de archivos en Nautilus'
  [p7zip]='Compresión 7z'
  [p7zip-plugins]='Complementos de compresión 7z'
  [file-roller]='Interfaz gráfica para archivos comprimidos'
  [vlc]='Reproductor multimedia VLC'
  [syncthing]='Sincronización de archivos entre dispositivos'
  [terminator]='Terminal Terminator'
  [vim-enhanced]='Editor Vim'
  [wl-clipboard]='Portapapeles para Wayland'
  [pipx]='Instalación aislada de aplicaciones Python'
  [input-remapper]='Remapeo de dispositivos de entrada'
  [code]='Visual Studio Code desde Microsoft'
  [firefox]='Firefox desde los repositorios DNF de Fedora'
)
