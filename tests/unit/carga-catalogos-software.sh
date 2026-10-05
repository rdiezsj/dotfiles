#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

resultado=$(bash -u -c '
  source "$1/platforms/fedora/catalogo-software.sh"
  cargar_catalogos_software "$1/catalogs"
  printf "%s|%s|%s|%s|%s|%s|%s\n" "${APPIMAGE_NOMBRE[heynote]}" "${DESCRIPCIONES_DNF[code]}" "${DESCRIPCIONES_FLATPAK[md.obsidian.Obsidian]}" "${PAQUETES_HOMEBREW[0]}" "${DESCRIPCIONES_DNF[nano]}" "${DESCRIPCIONES_DNF[msmtp]}" "${DESCRIPCIONES_DNF[flameshot]}"
' _ "$RAIZ")

[[ $resultado == 'Heynote_2.9.1_x86_64.AppImage|Visual Studio Code desde Microsoft|Gestor de conocimiento Obsidian|firefoxpwa|Editor de texto Nano|Cliente SMTP compatible con sendmail|Capturas de pantalla Flameshot' ]]
