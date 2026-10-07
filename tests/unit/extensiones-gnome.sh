#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/extensiones-gnome.sh"

registro="$TEMPORAL/registro"
operaciones="$TEMPORAL/operaciones"
registrar_resultado() {
  printf '%s:%s\n' "$1" "$2" >>"$registro"
}

declare -A disponibles=()
declare -A activas=()
fallo_ego_uuid=
gnome-shell() { printf '%s\n' 'GNOME Shell 50.1'; }
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
    info) [[ ${disponibles[$2]:-false} == true ]] ;;
    list)
      [[ $2 == --enabled ]] || return 1
      local uuid
      for uuid in "${!activas[@]}"; do
        [[ ${activas[$uuid]} == true ]] && printf '%s\n' "$uuid"
      done
      ;;
    install)
      [[ $2 == --force ]] || return 1
      local uuid
      uuid=$(<"$3")
      disponibles[$uuid]=true
      printf 'instala:%s\n' "$uuid" >>"$operaciones"
      ;;
    enable)
      [[ ${disponibles[$2]:-false} == true ]] || return 1
      activas[$2]=true
      printf 'activa:%s\n' "$2" >>"$operaciones"
      ;;
    *) return 1 ;;
  esac
}

appindicator=${EXTENSION_GNOME_UUID[appindicator]}
dash_to_dock=${EXTENSION_GNOME_UUID[dash-to-dock]}
disponibles[$appindicator]=true
disponibles[$dash_to_dock]=true

ejecutar_extensiones_gnome
for id in "${EXTENSIONES_GNOME[@]}"; do
  uuid=${EXTENSION_GNOME_UUID[$id]}
  [[ ${disponibles[$uuid]} == true ]]
  [[ ${activas[$uuid]} == true ]]
done
grep -Fqx "instalados:AppIndicator ($appindicator): activada" "$registro"
grep -Fqx "instalados:Custom Hot Corners Extended (${EXTENSION_GNOME_UUID[custom-hot-corners]}): instalada desde extensions.gnome.org" "$registro"
grep -Fqx "instalados:Clipboard Indicator (${EXTENSION_GNOME_UUID[clipboard-indicator]}): instalada desde extensions.gnome.org" "$registro"
grep -Fqx "instalados:Vitals (${EXTENSION_GNOME_UUID[vitals]}): instalada desde extensions.gnome.org" "$registro"
grep -Fqx "instalados:Dash to Dock ($dash_to_dock): activada" "$registro"

: >"$registro"
: >"$operaciones"
ejecutar_extensiones_gnome
[[ ! -s $operaciones ]]
for id in "${EXTENSIONES_GNOME[@]}"; do
  uuid=${EXTENSION_GNOME_UUID[$id]}
  grep -Fqx "presentes:${EXTENSION_GNOME_NOMBRE[$id]} ($uuid): ya estaba activa" "$registro"
done

: >"$registro"
: >"$operaciones"
clipboard=${EXTENSION_GNOME_UUID[clipboard-indicator]}
unset 'disponibles[$clipboard]' 'activas[$clipboard]'
fallo_ego_uuid=$clipboard
if ejecutar_extensiones_gnome; then
  exit 1
fi
grep -Fqx "fallidos:Clipboard Indicator ($clipboard): no hay una publicación compatible en extensions.gnome.org" "$registro"
grep -Fqx "presentes:Vitals (${EXTENSION_GNOME_UUID[vitals]}): ya estaba activa" "$registro"
! grep -Eq 'git|copr|make|gcc' "$RAIZ/platforms/fedora/extensiones-gnome.sh"
