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
registrar_resultado() { printf '%s:%s\n' "$1" "$2" >>"$registro"; }
declare -A activas=()
fallo_uuid=
gnome-shell() { printf '%s\n' 'GNOME Shell 50.1'; }
rpm() {
  case $1:$2 in
    -q:gnome-shell-extension-appindicator|-q:gnome-shell-extension-dash-to-dock) return 0 ;;
    -ql:gnome-shell-extension-appindicator) printf '%s\n' '/usr/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com/metadata.json' ;;
    -ql:gnome-shell-extension-dash-to-dock) printf '%s\n' '/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/metadata.json' ;;
    *) return 1 ;;
  esac
}
for id in custom-hot-corners clipboard-indicator vitals; do
  mkdir -p "$HOME/.local/share/gnome-shell/extensions/${EXTENSION_GNOME_UUID[$id]}"
  : >"$HOME/.local/share/gnome-shell/extensions/${EXTENSION_GNOME_UUID[$id]}/metadata.json"
done
gnome-extensions() {
  case $1 in
    list)
      for uuid in "${!activas[@]}"; do [[ ${activas[$uuid]} == true ]] && printf '%s\n' "$uuid"; done
      ;;
    enable)
      [[ $2 != "$fallo_uuid" ]] || { printf '%s\n' 'extensión no disponible' >&2; return 1; }
      activas[$2]=true
      ;;
    *) return 1 ;;
  esac
}

ejecutar_activacion_extensiones_gnome
for id in "${EXTENSIONES_GNOME[@]}"; do
  uuid=${EXTENSION_GNOME_UUID[$id]}
  [[ ${activas[$uuid]} == true ]]
done
! grep -q '^fallidos:' "$registro"

: >"$registro"
fallo_uuid=${EXTENSION_GNOME_UUID[vitals]}
unset 'activas[$fallo_uuid]'
if ejecutar_activacion_extensiones_gnome; then exit 1; fi
grep -Fqx "fallidos:Vitals ($fallo_uuid): no se pudo activar: extensión no disponible" "$registro"
bash -n "$RAIZ/scripts/activar-extensiones-gnome.sh"
