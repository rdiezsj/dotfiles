#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
for catalogo in dnf-rpm flatpak homebrew appimage; do
  archivo="$RAIZ/catalogs/$catalogo.sh"
  test -f "$archivo"
  grep -q '^# ' "$archivo"
  bash -n "$archivo"
done

# shellcheck source=/dev/null
source "$RAIZ/catalogs/dnf-rpm.sh"
# shellcheck source=/dev/null
source "$RAIZ/catalogs/flatpak.sh"
# shellcheck source=/dev/null
source "$RAIZ/catalogs/appimage.sh"
# shellcheck source=/dev/null
source "$RAIZ/catalogs/homebrew.sh"

[[ $(printf '%s\n' "${PAQUETES_DNF[@]}" | sort -u | wc -l) -eq ${#PAQUETES_DNF[@]} ]]
[[ $(printf '%s\n' "${PAQUETES_FLATPAK[@]}" | sort -u | wc -l) -eq ${#PAQUETES_FLATPAK[@]} ]]
printf '%s\n' "${PAQUETES_FLATPAK[@]}" | grep -Fxq org.gnome.Extensions
[[ ${DESCRIPCIONES_FLATPAK[org.gnome.Extensions]} == 'Gestor de extensiones de GNOME' ]]
[[ ${#PAQUETES_APPIMAGE[@]} -eq 2 ]]
for appimage in "${PAQUETES_APPIMAGE[@]}"; do
  [[ ${APPIMAGE_URL[$appimage]} == https://* ]]
  [[ ${APPIMAGE_SHA256[$appimage]} =~ ^[[:xdigit:]]{64}$ ]]
done
! printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq firefoxpwa
printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq zip
printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq unzip
printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq gnome-shell-extension-appindicator
printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq gnome-shell-extension-dash-to-dock
printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq libgtop2-devel
printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq lm_sensors
printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq ptyxis
! printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq zellij
printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq dconf
[[ ${DESCRIPCIONES_DNF[gnome-shell-extension-appindicator]} == 'Indicadores de aplicaciones para GNOME Shell' ]]
[[ ${DESCRIPCIONES_DNF[gnome-shell-extension-dash-to-dock]} == 'Dock configurable para GNOME Shell' ]]
[[ ${DESCRIPCIONES_DNF[libgtop2-devel]} == 'Biblioteca de métricas del sistema para Vitals' ]]
[[ ${DESCRIPCIONES_DNF[lm_sensors]} == 'Lectura de sensores de hardware para Vitals' ]]
[[ ${DESCRIPCIONES_DNF[ptyxis]} == 'Terminal principal de GNOME' ]]
[[ ${DESCRIPCIONES_DNF[dconf]} == 'Herramienta de configuración para aplicaciones GNOME' ]]
[[ ${PAQUETES_HOMEBREW[*]} == 'firefoxpwa starship sheldon fzf helm kubernetes-cli kubectx zellij openspec' ]]
[[ $(printf '%s\n' "${PAQUETES_HOMEBREW[@]}" | sort -u | wc -l) -eq ${#PAQUETES_HOMEBREW[@]} ]]
! printf '%s\n' "${PAQUETES_HOMEBREW[@]}" | grep -Fxq zsh-completions
printf '%s\n' "${PAQUETES_HOMEBREW[@]}" | grep -Fxq sheldon
printf '%s\n' "${PAQUETES_HOMEBREW[@]}" | grep -Fxq zellij
