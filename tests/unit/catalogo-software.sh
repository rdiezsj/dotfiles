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
  case $1:$2:$3:$4 in
    dnf:install:-y:gnome-tweaks|dnf:install:-y:nano|dnf:install:-y:fuse-libs|dnf:install:-y:gnome-shell-extension-appindicator|dnf:install:-y:gnome-shell-extension-dash-to-dock|dnf:install:-y:libgtop2-devel|dnf:install:-y:lm_sensors|dnf:install:-y:msmtp|dnf:install:-y:flameshot) return 0 ;;
  esac
  return 1
}
instalar_paquete_dnf gnome-tweaks
grep -Fqx 'instalados:DNF: gnome-tweaks instalado' "$registro"
instalar_paquete_dnf nano
instalar_paquete_dnf msmtp
instalar_paquete_dnf flameshot
instalar_paquete_dnf fuse-libs
instalar_paquete_dnf gnome-shell-extension-appindicator
instalar_paquete_dnf gnome-shell-extension-dash-to-dock
instalar_paquete_dnf libgtop2-devel
instalar_paquete_dnf lm_sensors
grep -Fqx 'instalados:DNF: nano instalado' "$registro"
grep -Fqx 'instalados:DNF: msmtp instalado' "$registro"
grep -Fqx 'instalados:DNF: flameshot instalado' "$registro"
grep -Fqx 'instalados:DNF: fuse-libs instalado' "$registro"
grep -Fqx 'instalados:DNF: gnome-shell-extension-appindicator instalado' "$registro"
grep -Fqx 'instalados:DNF: gnome-shell-extension-dash-to-dock instalado' "$registro"
grep -Fqx 'instalados:DNF: libgtop2-devel instalado' "$registro"
grep -Fqx 'instalados:DNF: lm_sensors instalado' "$registro"

rpm() { [[ $1 == -q && $2 == gnome-shell-extension-appindicator ]]; }
instalar_paquete_dnf gnome-shell-extension-appindicator
grep -Fqx 'presentes:DNF: gnome-shell-extension-appindicator ya estaba instalado' "$registro"

ptyxis() { [[ $1 == --version ]]; }
verificar_terminal ptyxis DNF
grep -Fqx 'presentes:Terminal: ptyxis disponible' "$registro"

zellij() { [[ $1 == --version ]]; }
verificar_terminal zellij Homebrew
grep -Fqx 'presentes:Terminal: zellij disponible' "$registro"

zellij() { return 1; }
if verificar_terminal zellij Homebrew; then exit 1; fi
grep -Fqx 'fallidos:Terminal: zellij no está disponible tras el catálogo Homebrew' "$registro"

flatpak() {
  case ${1-}:${2-}:${3-}:${4-}:${5-} in
    info:--user:it.mijorus.gearlever::) return 0 ;;
    run:--command=gsettings:it.mijorus.gearlever:get:it.mijorus.gearlever)
      printf "'%s'\n" "$HOME/AppImages"
      ;;
    run:--command=gsettings:it.mijorus.gearlever:set:it.mijorus.gearlever)
      [[ ${6-} == appimages-default-folder && ${7-} == "$HOME/Apps" ]]
      ;;
    *) return 1 ;;
  esac
}
configurar_carpeta_gear_lever
grep -Fqx "instalados:Gear Lever: carpeta predeterminada configurada en $HOME/Apps" "$registro"
flatpak() {
  case ${1-}:${2-}:${3-}:${4-}:${5-} in
    info:--user:it.mijorus.gearlever::) return 0 ;;
    run:--command=gsettings:it.mijorus.gearlever:get:it.mijorus.gearlever)
      printf "'%s'\n" "$HOME/Apps"
      ;;
    *) return 1 ;;
  esac
}
configurar_carpeta_gear_lever
grep -Fqx "presentes:Gear Lever: carpeta predeterminada ya configurada en $HOME/Apps" "$registro"
flatpak() { return 1; }
if configurar_carpeta_gear_lever; then exit 1; fi
grep -Fqx 'fallidos:Gear Lever: no está disponible para configurar la carpeta predeterminada' "$registro"

ldconfig() { printf '\tlibfuse.so.2 (libc6) => /usr/lib64/libfuse.so.2\n'; }
verificar_fuse_appimage
grep -Fqx 'presentes:FUSE: biblioteca libfuse.so.2 disponible para AppImage v2' "$registro"
ldconfig() { return 0; }
if verificar_fuse_appimage; then exit 1; fi
grep -Fqx 'fallidos:FUSE: falta libfuse.so.2 para ejecutar AppImage v2; revisa la instalación de fuse-libs' "$registro"

fedora_release=44
arquitectura_prueba=x86_64
chatgpt_instalado=false
rpm() {
  if [[ $1 == -E && $2 == %fedora ]]; then printf '%s\n' "$fedora_release"; return 0; fi
  [[ $1 == -q && $2 == chatgpt && $chatgpt_instalado == true ]]
}
uname() { printf '%s\n' "$arquitectura_prueba"; }
sudo() {
  [[ $1 == dnf && $2 == install && $3 == -y ]] || return 1
  [[ $4 == "$URL_CHATGPT_X86_64" || $4 == "$URL_CHATGPT_AARCH64" ]] || return 1
  chatgpt_instalado=true
}
instalar_chatgpt
grep -Fqx 'instalados:ChatGPT: RPM oficial instalado' "$registro"
chatgpt_instalado=false
arquitectura_prueba=aarch64
sudo() {
  [[ $1 == dnf && $2 == install && $3 == -y && $4 == "$URL_CHATGPT_AARCH64" ]] || return 1
  chatgpt_instalado=true
}
instalar_chatgpt
grep -Fqx 'instalados:ChatGPT: RPM oficial instalado' "$registro"
chatgpt_instalado=false
fedora_release=42
instalar_chatgpt
grep -Fqx 'omitidos:ChatGPT: Fedora 42 no está admitida por OpenAI' "$registro"
fedora_release=44
arquitectura_prueba=ppc64le
instalar_chatgpt
grep -Fqx 'omitidos:ChatGPT: arquitectura ppc64le no admitida por OpenAI' "$registro"
arquitectura_prueba=aarch64
sudo() { return 1; }
if instalar_chatgpt; then exit 1; fi
grep -Fqx 'fallidos:ChatGPT: no se pudo instalar el RPM oficial' "$registro"
chatgpt_instalado=true
instalar_chatgpt
grep -Fqx 'presentes:ChatGPT: ya estaba instalado' "$registro"

operaciones_flatpak="$TEMPORAL/operaciones-flatpak"
flathub_url=
flatpak() {
  case $1 in
    remote-get-url)
      [[ -n $flathub_url ]] || return 1
      printf '%s\n' "$flathub_url"
      ;;
    remote-add)
      [[ $2 == --user && $3 == --if-not-exists && $4 == flathub && $5 == "$URL_FLATHUB" ]] || return 1
      flathub_url=$5
      printf 'remote-add:%s\n' "$flathub_url" >>"$operaciones_flatpak"
      ;;
    remote-modify)
      [[ $2 == --user && $3 == "--url=$URL_FLATHUB" && $4 == flathub ]] || return 1
      flathub_url=$URL_FLATHUB
      printf 'remote-modify:%s\n' "$flathub_url" >>"$operaciones_flatpak"
      ;;
    *) return 1 ;;
  esac
}
configurar_flathub
grep -Fqx "remote-add:$URL_FLATHUB" "$operaciones_flatpak"
[[ $flathub_url == "$URL_FLATHUB" ]]
: >"$operaciones_flatpak"
configurar_flathub
[[ ! -s $operaciones_flatpak ]]
flathub_url='https://example.invalid/flathub.flatpakrepo'
configurar_flathub
grep -Fqx "remote-modify:$URL_FLATHUB" "$operaciones_flatpak"

flatpak() {
  case $1 in
    info) return 1 ;;
    install) [[ $2 == --user && $3 == -y && $4 == flathub && $5 == org.gnome.Extensions ]] ;;
    *) return 1 ;;
  esac
}
instalar_paquete_flatpak org.gnome.Extensions
grep -Fqx 'instalados:Flatpak: org.gnome.Extensions instalado' "$registro"

rpm() { [[ $1 == -q && $2 == syncthing ]]; }
systemctl() {
  [[ $1 == --user && $2 == is-enabled ]] && return 1
  [[ $1 == --user && $2 == enable && $3 == --now && $4 == syncthing.service ]]
}
habilitar_syncthing_usuario
grep -Fqx 'instalados:Syncthing: servicio de usuario habilitado e iniciado' "$registro"

rpm() { [[ $1 == -q && $2 == input-remapper ]]; }
systemctl() {
  [[ $1 == is-enabled && $2 == --quiet && $3 == input-remapper.service ]] && return 1
  [[ $1 == enable && $2 == --now && $3 == input-remapper.service ]]
}
sudo() { "$@"; }
habilitar_input_remapper_sistema
grep -Fqx 'instalados:Input Remapper: servicio de sistema habilitado e iniciado' "$registro"

systemctl() { [[ $1 == is-enabled && $2 == --quiet && $3 == input-remapper.service ]]; }
habilitar_input_remapper_sistema
grep -Fqx 'presentes:Input Remapper: servicio de sistema ya habilitado' "$registro"

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
    install) [[ $2 == firefoxpwa || $2 == starship || $2 == zellij ]] ;;
    *) return 1 ;;
  esac
}
instalar_paquete_homebrew firefoxpwa
grep -Fqx 'instalados:Homebrew: firefoxpwa instalado' "$registro"
instalar_paquete_homebrew starship
grep -Fqx 'instalados:Homebrew: starship instalado' "$registro"
instalar_paquete_homebrew zellij
grep -Fqx 'instalados:Homebrew: zellij instalado' "$registro"

openspec() { printf 'OpenSpec 1.14.0\n'; }
brew() { printf 'brew no debe instalar OpenSpec si ya hay CLI funcional\n' >&2; return 1; }
instalar_openspec_global
grep -Fqx 'presentes:OpenSpec: CLI global funcional (OpenSpec 1.14.0)' "$registro"
unset -f openspec
path_previo=$PATH
PATH=$TEMPORAL/bin
brew() { [[ $1 == install && $2 == openspec ]]; }
instalar_openspec_global
PATH=$path_previo
grep -Fqx 'instalados:Homebrew: openspec instalado' "$registro"
PATH=$TEMPORAL/bin
openspec() { return 1; }
brew() { [[ $1 == install && $2 == openspec ]]; }
instalar_openspec_global
PATH=$path_previo
grep -Fqx 'instalados:Homebrew: openspec instalado' "$registro"
unset -f openspec

brew() {
  [[ $1 == list && $2 == --versions && $3 == firefoxpwa ]]
}
instalar_paquete_homebrew firefoxpwa
grep -Fqx 'presentes:Homebrew: firefoxpwa ya estaba instalado' "$registro"

brew() {
  [[ $1 == list && $2 == --versions && $3 == zellij ]]
}
instalar_paquete_homebrew zellij
grep -Fqx 'presentes:Homebrew: zellij ya estaba instalado' "$registro"

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
