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
[[ ${#PAQUETES_APPIMAGE[@]} -eq 2 ]]
for appimage in "${PAQUETES_APPIMAGE[@]}"; do
  [[ ${APPIMAGE_URL[$appimage]} == https://* ]]
  [[ ${APPIMAGE_SHA256[$appimage]} =~ ^[[:xdigit:]]{64}$ ]]
done
! printf '%s\n' "${PAQUETES_DNF[@]}" | grep -Fxq firefoxpwa
[[ ${PAQUETES_HOMEBREW[*]} == 'firefoxpwa starship zsh-completions fzf helm kubernetes-cli kubectx' ]]
[[ $(printf '%s\n' "${PAQUETES_HOMEBREW[@]}" | sort -u | wc -l) -eq ${#PAQUETES_HOMEBREW[@]} ]]
