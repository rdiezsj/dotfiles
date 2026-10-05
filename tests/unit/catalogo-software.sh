#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
export HOME="$TEMPORAL/home"
mkdir -p "$HOME/Apps"

# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/catalogo-software.sh"
# shellcheck source=/dev/null
source "$RAIZ/catalogs/appimage.sh"
# shellcheck source=/dev/null
source "$RAIZ/catalogs/homebrew.sh"
# shellcheck source=/dev/null
source "$RAIZ/catalogs/flatpak.sh"

registro=$(mktemp)
registrar_resultado() {
  printf '%s:%s\n' "$1" "$2" >>"$registro"
}

bloques=$(mktemp)
mostrar_fase() {
  printf '%s\n' "$1" >>"$bloques"
}
mostrar_bloque_catalogo 'DNF/RPM'
mostrar_bloque_catalogo 'HOMEBREW'
mostrar_bloque_catalogo 'FLATPAK'
mostrar_bloque_catalogo 'APPIMAGE'
[[ $(paste -sd '|' "$bloques") == 'CATÁLOGO DNF/RPM|CATÁLOGO HOMEBREW|CATÁLOGO FLATPAK|CATÁLOGO APPIMAGE' ]]

rpm() { return 1; }
sudo() {
  [[ $1 == dnf && $2 == install && $3 == -y && $4 == gnome-tweaks ]]
}
instalar_paquete_dnf gnome-tweaks
grep -Fqx 'instalados:DNF: gnome-tweaks instalado' "$registro"

flatpak() {
  case $1 in
    info) return 1 ;;
    install) [[ $2 == --user && $3 == -y && $4 == flathub && $5 == md.obsidian.Obsidian ]] ;;
    remote-get-url) return 0 ;;
    *) return 1 ;;
  esac
}
instalar_paquete_flatpak md.obsidian.Obsidian
grep -Fqx 'instalados:Flatpak: md.obsidian.Obsidian instalado' "$registro"

rpm() { [[ $1 == -q && $2 == syncthing ]]; }
systemctl() {
  [[ $1 == --user && $2 == is-enabled ]] && return 1
  [[ $1 == --user && $2 == enable && $3 == --now && $4 == syncthing.service ]]
}
habilitar_syncthing_usuario
grep -Fqx 'instalados:Syncthing: servicio de usuario habilitado e iniciado' "$registro"

origen="$TEMPORAL/origen"
printf 'appimage de prueba' >"$origen"
sha=$(sha256sum "$origen" | awk '{print $1}')
APPIMAGE_NOMBRE[prueba]='Prueba.AppImage'
APPIMAGE_SHA256[prueba]=$sha
APPIMAGE_URL[prueba]="file://$origen"
curl() { cp "${APPIMAGE_URL[prueba]#file://}" "$6"; }
instalar_appimage prueba
[[ -x $HOME/Apps/Prueba.AppImage ]]
grep -Fqx "pendientes:Gear Lever: importa manualmente $HOME/Apps/Prueba.AppImage" "$registro"
instalar_appimage prueba
grep -Fqx 'presentes:AppImage: Prueba.AppImage ya estaba verificado' "$registro"
[[ $(grep -Fc "pendientes:Gear Lever: importa manualmente $HOME/Apps/Prueba.AppImage" "$registro") -eq 2 ]]
printf 'contenido distinto' >"$HOME/Apps/Conflicto.AppImage"
APPIMAGE_NOMBRE[conflicto]='Conflicto.AppImage'
APPIMAGE_SHA256[conflicto]=$sha
APPIMAGE_URL[conflicto]="file://$origen"
instalar_appimage conflicto
grep -Fqx "pendientes:AppImage: conflicto en $HOME/Apps/Conflicto.AppImage; no se reemplazó" "$registro"

APPIMAGE_NOMBRE[invalido]='Invalido.AppImage'
APPIMAGE_SHA256[invalido]=$(printf '0%.0s' {1..64})
APPIMAGE_URL[invalido]="file://$origen"
if instalar_appimage invalido; then
  exit 1
fi
[[ ! -e $HOME/Apps/Invalido.AppImage ]]
grep -Fqx 'fallidos:AppImage: suma SHA-256 inválida para Invalido.AppImage' "$registro"

ruta_brew() { printf '%s\n' brew; }
brew() {
  case $1 in
    list) return 1 ;;
    install) [[ $2 == firefoxpwa || $2 == starship ]] ;;
    *) return 1 ;;
  esac
}
instalar_paquete_homebrew firefoxpwa
grep -Fqx 'instalados:Homebrew: firefoxpwa instalado' "$registro"
instalar_paquete_homebrew starship
grep -Fqx 'instalados:Homebrew: starship instalado' "$registro"

brew() {
  [[ $1 == list && $2 == --versions && $3 == firefoxpwa ]]
}
instalar_paquete_homebrew firefoxpwa
grep -Fqx 'presentes:Homebrew: firefoxpwa ya estaba instalado' "$registro"

brew() { return 1; }
if instalar_paquete_homebrew firefoxpwa; then
  exit 1
fi
grep -Fqx 'fallidos:Homebrew: no se pudo instalar firefoxpwa' "$registro"

ruta_brew() { return 1; }
if instalar_paquete_homebrew firefoxpwa; then
  exit 1
fi
grep -Fqx 'fallidos:Homebrew: no está disponible para instalar firefoxpwa' "$registro"

cargar_catalogos_software() {
  PAQUETES_DNF=()
  PAQUETES_HOMEBREW=(fallida siguiente)
  PAQUETES_FLATPAK=()
  PAQUETES_APPIMAGE=()
  FLATPAK_EXCLUIDOS=()
}
rpm() { return 1; }
snap() { return 1; }
flatpak() { return 0; }
systemctl() { return 1; }
ruta_brew() { printf '%s\n' brew; }
brew() {
  [[ $1 == install ]] || return 1
  case "$2" in
    fallida) return 1 ;;
    siguiente) [[ $1 == install ]] ;;
  esac
}
ejecutar_catalogo_software "$RAIZ/catalogs"
grep -Fqx 'fallidos:Homebrew: no se pudo instalar fallida' "$registro"
grep -Fqx 'instalados:Homebrew: siguiente instalado' "$registro"

operaciones="$TEMPORAL/operaciones"
FLATPAK_EXCLUIDOS=(org.mozilla.firefox)
flatpak() {
  case $1 in
    info) [[ $3 == org.mozilla.firefox ]] ;;
    uninstall) printf 'flatpak:%s\n' "$4" >>"$operaciones" ;;
    *) return 1 ;;
  esac
}
snap() { [[ $1 == list && $2 == firefox ]]; }
sudo() { [[ $1 == snap && $2 == remove && $3 == firefox ]] && printf 'snap:%s\n' "$3" >>"$operaciones"; }
reconciliar_aplicaciones_exclusivas
grep -Fqx 'flatpak:org.mozilla.firefox' "$operaciones"
grep -Fqx 'snap:firefox' "$operaciones"
[[ $(wc -l <"$operaciones") -eq 2 ]]
