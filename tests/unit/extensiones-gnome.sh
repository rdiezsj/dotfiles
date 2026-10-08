#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
export HOME="$TEMPORAL/home"
mkdir -p "$HOME"

# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/extensiones-gnome.sh"

registro="$TEMPORAL/registro"
operaciones="$TEMPORAL/operaciones"
registrar_resultado() {
  printf '%s:%s\n' "$1" "$2" >>"$registro"
}

declare -A activas=()
fallo_ego_uuid=
sesion_recargada=false
gnome-shell() { printf '%s\n' 'GNOME Shell 50.1'; }
rpm() {
  case $1:$2 in
    -q:gnome-shell-extension-appindicator|-q:gnome-shell-extension-dash-to-dock) return 0 ;;
    -ql:gnome-shell-extension-appindicator)
      printf '%s\n' '/usr/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com/metadata.json'
      ;;
    -ql:gnome-shell-extension-dash-to-dock)
      printf '%s\n' '/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/metadata.json'
      ;;
    *) return 1 ;;
  esac
}
curl() {
  local url=${!#}
  if [[ $url == *'/extension-info/?uuid='* ]]; then
    local uuid=${url#*uuid=}
    uuid=${uuid%%&*}
    if [[ $uuid == "$fallo_ego_uuid" ]]; then
      printf '%s' '{}'
    else
      printf '{"download_url":"/download-extension/%s.shell-extension.zip?version_tag=123"}' "$uuid"
    fi
    return 0
  fi
  [[ $1 == --fail && $2 == --location && $3 == --silent && $4 == --show-error && $5 == --output ]] || return 1
  local archivo=$6
  local uuid=${url#*/download-extension/}
  uuid=${uuid%.shell-extension.zip*}
  printf '%s\n' "$uuid" >"$archivo"
  printf 'descarga:%s\n' "$uuid" >>"$operaciones"
}
gnome-extensions() {
  case $1 in
    list)
      [[ $2 == --enabled ]] || return 1
      local uuid
      if [[ $sesion_recargada == true ]]; then
        for uuid in "${!activas[@]}"; do
          [[ ${activas[$uuid]} == true ]] && printf '%s\n' "$uuid"
        done
      fi
      ;;
    install)
      [[ $2 == --force ]] || return 1
      local uuid
      uuid=$(<"$3")
      mkdir -p "$HOME/.local/share/gnome-shell/extensions/$uuid"
      : >"$HOME/.local/share/gnome-shell/extensions/$uuid/metadata.json"
      printf 'instala:%s\n' "$uuid" >>"$operaciones"
      ;;
    enable)
      activas[$2]=true
      printf 'activa:%s\n' "$2" >>"$operaciones"
      ;;
    *) return 1 ;;
  esac
}

appindicator=${EXTENSION_GNOME_UUID[appindicator]}
dash_to_dock=${EXTENSION_GNOME_UUID[dash-to-dock]}

ejecutar_extensiones_gnome
for id in custom-hot-corners clipboard-indicator vitals; do
  uuid=${EXTENSION_GNOME_UUID[$id]}
  [[ -f $HOME/.local/share/gnome-shell/extensions/$uuid/metadata.json ]]
  [[ ${activas[$uuid]} == true ]]
done
[[ ${activas[$appindicator]} == true ]]
[[ ${activas[$dash_to_dock]} == true ]]
grep -Fqx "instalados:Custom Hot Corners Extended (${EXTENSION_GNOME_UUID[custom-hot-corners]}): instalada desde extensions.gnome.org" "$registro"
grep -Fqx "instalados:Clipboard Indicator (${EXTENSION_GNOME_UUID[clipboard-indicator]}): instalada desde extensions.gnome.org" "$registro"
grep -Fqx "instalados:Vitals (${EXTENSION_GNOME_UUID[vitals]}): instalada desde extensions.gnome.org" "$registro"
grep -Fqx "pendientes:AppIndicator ($appindicator): cierra e inicia sesión y ejecuta activar-extensiones-gnome" "$registro"
grep -Fqx "pendientes:Dash to Dock ($dash_to_dock): cierra e inicia sesión y ejecuta activar-extensiones-gnome" "$registro"
grep -Fqx "pendientes:Clipboard Indicator (${EXTENSION_GNOME_UUID[clipboard-indicator]}): cierra e inicia sesión y ejecuta activar-extensiones-gnome" "$registro"

: >"$registro"
sesion_recargada=false
gnome-extensions() {
  case $1 in
    list) [[ $2 == --enabled ]] ;;
    enable) return 1 ;;
    *) return 1 ;;
  esac
}
ejecutar_extensiones_gnome
! grep -q '^fallidos:.*no se pudo activar' "$registro"
grep -Fqx "pendientes:AppIndicator ($appindicator): cierra e inicia sesión y ejecuta activar-extensiones-gnome" "$registro"

gnome-extensions() {
  case $1 in
    list)
      [[ $2 == --enabled ]] || return 1
      local uuid
      if [[ $sesion_recargada == true ]]; then
        for uuid in "${!activas[@]}"; do
          [[ ${activas[$uuid]} == true ]] && printf '%s\n' "$uuid"
        done
      fi
      ;;
    install)
      [[ $2 == --force ]] || return 1
      local uuid
      uuid=$(<"$3")
      mkdir -p "$HOME/.local/share/gnome-shell/extensions/$uuid"
      : >"$HOME/.local/share/gnome-shell/extensions/$uuid/metadata.json"
      printf 'instala:%s\n' "$uuid" >>"$operaciones"
      ;;
    enable)
      activas[$2]=true
      printf 'activa:%s\n' "$2" >>"$operaciones"
      ;;
    *) return 1 ;;
  esac
}

: >"$registro"
: >"$operaciones"
sesion_recargada=true
ejecutar_extensiones_gnome
[[ ! -s $operaciones ]]
for id in "${EXTENSIONES_GNOME[@]}"; do
  uuid=${EXTENSION_GNOME_UUID[$id]}
  grep -Fqx "presentes:${EXTENSION_GNOME_NOMBRE[$id]} ($uuid): ya estaba activa" "$registro"
done

: >"$registro"
: >"$operaciones"
clipboard=${EXTENSION_GNOME_UUID[clipboard-indicator]}
rm -rf "$HOME/.local/share/gnome-shell/extensions/$clipboard"
unset 'activas[$clipboard]'
fallo_ego_uuid=$clipboard
if ejecutar_extensiones_gnome; then
  exit 1
fi
grep -Fqx "fallidos:Clipboard Indicator ($clipboard): no hay una publicación compatible en extensions.gnome.org" "$registro"
grep -Fqx "presentes:Vitals (${EXTENSION_GNOME_UUID[vitals]}): ya estaba activa" "$registro"
! grep -Eq 'git|copr|make|gcc' "$RAIZ/platforms/fedora/extensiones-gnome.sh"
