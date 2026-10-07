#!/usr/bin/env bash

# Catálogo DNF/RPM de la estación Fedora. Cada elemento se gestiona de forma
# idempotente y sus fuentes externas se validan antes de usarlo.
PAQUETES_DNF=(
  gnome-tweaks
  sushi
  p7zip
  p7zip-plugins
  zip
  unzip
  file-roller
  vlc
  syncthing
  terminator
  nano
  vim-enhanced
  wl-clipboard
  pipx
  input-remapper
  fuse-libs
  msmtp
  flameshot
  code
  firefox
)

declare -gA DESCRIPCIONES_DNF=(
  [gnome-tweaks]='Ajustes adicionales para GNOME'
  [sushi]='Vista previa rápida de archivos en Nautilus'
  [p7zip]='Compresión 7z'
  [p7zip-plugins]='Complementos de compresión 7z'
  [zip]='Creación de archivos ZIP'
  [unzip]='Extracción de archivos ZIP'
  [file-roller]='Interfaz gráfica para archivos comprimidos'
  [vlc]='Reproductor multimedia VLC'
  [syncthing]='Sincronización de archivos entre dispositivos'
  [terminator]='Terminal Terminator'
  [nano]='Editor de texto Nano'
  [vim-enhanced]='Editor Vim'
  [wl-clipboard]='Portapapeles para Wayland'
  [pipx]='Instalación aislada de aplicaciones Python'
  [input-remapper]='Remapeo de dispositivos de entrada'
  [fuse-libs]='Biblioteca FUSE v2 para AppImage'
  [msmtp]='Cliente SMTP compatible con sendmail'
  [flameshot]='Capturas de pantalla Flameshot'
  [code]='Visual Studio Code desde Microsoft'
  [firefox]='Firefox desde los repositorios DNF de Fedora'
)
