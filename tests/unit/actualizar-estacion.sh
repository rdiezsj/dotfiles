#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
export HOME="$TEMPORAL/home"
mkdir -p "$HOME/Apps" "$TEMPORAL/checkout/.git" "$TEMPORAL/bin"

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/resumen-bootstrap.sh"
# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/actualizar-estacion.sh"

operaciones="$TEMPORAL/operaciones"
git() {
  shift 2
  case $1:$2 in
    diff:--quiet|diff:--cached) [[ ${GIT_SUCIO:-false} == false ]] ;;
    branch:--show-current) printf '%s\n' main ;;
    fetch:origin) printf 'fetch:%s\n' "$3" >>"$operaciones" ;;
    merge:--ff-only) [[ ${GIT_DIVERGE:-false} == false ]] && printf 'merge:%s\n' "$3" >>"$operaciones" ;;
    *) return 1 ;;
  esac
}
actualizar_checkout_dotfiles "$TEMPORAL/checkout"
grep -Fqx 'fetch:main' "$operaciones"
grep -Fqx 'merge:FETCH_HEAD' "$operaciones"
GIT_SUCIO=true
if actualizar_checkout_dotfiles "$TEMPORAL/checkout"; then exit 1; fi
[[ $(grep -Fc 'fetch:main' "$operaciones") == 1 ]]
GIT_SUCIO=false
GIT_DIVERGE=true
if actualizar_checkout_dotfiles "$TEMPORAL/checkout"; then exit 1; fi
[[ $(grep -Fc 'merge:FETCH_HEAD' "$operaciones") == 1 ]]
GIT_DIVERGE=false

falso="$TEMPORAL/falso"
mkdir -p "$falso/scripts/lib" "$falso/home"
cat >"$falso/scripts/lib/zsh-terminal.sh" <<'EOF'
listar_destinos_dotbot() { printf '%s\n' "$HOME/.config/prueba"; }
origen_dotfile() { printf '%s\n' "$1/home/prueba"; }
destino_zsh_gestionado() { [[ -L $2 && $(readlink -f "$2") == $(readlink -f "$1/home/prueba") ]]; }
ejecutar_dotbot_zsh() { mkdir -p "$HOME/.config"; ln -sfn "$1/home/prueba" "$HOME/.config/prueba"; }
EOF
printf 'gestionada\n' >"$falso/home/prueba"
actualizar_configuraciones_dotbot "$falso"
[[ -L $HOME/.config/prueba ]]
rm "$HOME/.config/prueba"
printf 'local\n' >"$HOME/.config/prueba"
if actualizar_configuraciones_dotbot "$falso"; then exit 1; fi
grep -Fqx local "$HOME/.config/prueba"

sudo() {
  [[ $1 == dnf ]] || return 1
  [[ $2 == upgrade && $3 == --refresh && $4 == -y ]] && return 0
  [[ $2 == needs-restarting && $3 == -r ]] && return 1
  return 1
}
actualizar_dnf
brew() { [[ $1 == update || $1 == upgrade ]]; }
PATH="$TEMPORAL/bin:$PATH"
printf '#!/usr/bin/env bash\nexit 0\n' >"$TEMPORAL/bin/brew"
chmod +x "$TEMPORAL/bin/brew"
actualizar_homebrew
flatpak() { [[ $1 == update && $2 == --user && $3 == -y ]]; }
actualizar_flatpak

declare -A APPIMAGE_MANIFIESTO_GITHUB=([prueba]=manifest)
PAQUETES_APPIMAGE=(prueba)
obtener_metadatos_appimage() { printf 'Prueba.AppImage\tfile://origen\t%s\n' "$SUMA_PRUEBA"; }
printf 'binario nuevo' >"$TEMPORAL/origen"
SUMA_PRUEBA=$(sha256sum "$TEMPORAL/origen" | awk '{print $1}')
curl() { cp "$TEMPORAL/origen" "$6"; }
actualizar_appimage_declarado prueba
[[ -x $HOME/Apps/Prueba.AppImage ]]
SUMA_PRUEBA=$(printf '0%.0s' {1..64})
if actualizar_appimage_declarado prueba; then exit 1; fi

operaciones_gnome="$TEMPORAL/operaciones-gnome"
gnome-shell() { printf '%s\n' 'GNOME Shell 50.1'; }
gnome-extensions() {
  [[ $1 == install && $2 == --force ]] || return 1
  printf '%s\n' "$3" >>"$operaciones_gnome"
}
curl() {
  local ultimo=${!#}
  if [[ $ultimo == *'/extension-info/?uuid='* ]]; then
    printf '{"download_url":"/download-extension/prueba.shell-extension.zip"}'
  else
    printf 'extension' >"$6"
  fi
}
actualizar_extensiones_gnome "$RAIZ"
[[ $(wc -l <"$operaciones_gnome") -eq 3 ]]
curl() { printf '%s' '{}'; }
if actualizar_extensiones_gnome "$RAIZ"; then exit 1; fi

RESULTADOS_INSTALADOS=()
RESULTADOS_PRESENTES=()
RESULTADOS_OMITIDOS=()
RESULTADOS_FALLIDOS=()
RESULTADOS_PENDIENTES=()
fases="$TEMPORAL/fases"
actualizar_checkout_dotfiles() { printf '%s\n' checkout >>"$fases"; registrar_resultado instalados checkout; }
actualizar_configuraciones_dotbot() { printf '%s\n' dotbot >>"$fases"; registrar_resultado fallidos dotbot; return 1; }
actualizar_dnf() { printf '%s\n' dnf >>"$fases"; registrar_resultado instalados dnf; }
actualizar_homebrew() { printf '%s\n' brew >>"$fases"; registrar_resultado instalados brew; }
actualizar_flatpak() { printf '%s\n' flatpak >>"$fases"; registrar_resultado instalados flatpak; }
actualizar_appimages() { printf '%s\n' appimage >>"$fases"; registrar_resultado omitidos appimage; }
actualizar_extensiones_gnome() { printf '%s\n' extensiones >>"$fases"; registrar_resultado instalados extensiones; }
if ejecutar_actualizacion_estacion "$RAIZ" >/dev/null; then exit 1; fi
[[ $(paste -sd '|' "$fases") == 'checkout|dotbot|dnf|brew|flatpak|appimage|extensiones' ]]

grep -Fqx "alias update='\$HOME/.dotfiles/scripts/actualizar.sh'" "$RAIZ/home/.zsh_aliases"
bash -n "$RAIZ/scripts/actualizar.sh" "$RAIZ/scripts/lib/actualizar-estacion.sh"
