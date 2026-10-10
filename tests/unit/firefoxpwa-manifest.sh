#!/usr/bin/env bash
set -euo pipefail
RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
source "$RAIZ/platforms/fedora/catalogo-software.sh"
mkdir -p "$TEMPORAL/formula/share" "$TEMPORAL/formula/bin"
printf '#!/bin/sh\nexit 0\n' >"$TEMPORAL/formula/bin/firefoxpwa-connector"
chmod +x "$TEMPORAL/formula/bin/firefoxpwa-connector"
jq -n --arg ruta "$TEMPORAL/formula/bin/firefoxpwa-connector" \
  '{name:"firefoxpwa",type:"stdio",path:$ruta}' >"$TEMPORAL/formula/share/firefoxpwa.json"
ruta_brew() { printf '%s\n' brew; }
brew() { [[ $* == '--prefix firefoxpwa' ]] && printf '%s\n' "$TEMPORAL/formula"; }
sudo() { "$@"; }
destino="$TEMPORAL/mozilla/firefoxpwa.json"
configurar_manifiesto_firefoxpwa "$destino"
[[ -L $destino && $destino -ef $TEMPORAL/formula/share/firefoxpwa.json ]]
marca=$(stat -c %Y "$destino")
configurar_manifiesto_firefoxpwa "$destino"
[[ $(stat -c %Y "$destino") == "$marca" ]]
rm "$destino"
printf '%s\n' ajeno >"$destino"
if configurar_manifiesto_firefoxpwa "$destino"; then exit 1; fi
[[ $(cat "$destino") == ajeno ]]
rm "$destino"
ln -s "$TEMPORAL/no-existe" "$destino"
if configurar_manifiesto_firefoxpwa "$destino"; then exit 1; fi
[[ $(readlink "$destino") == "$TEMPORAL/no-existe" ]]
rm "$destino"
rm "$TEMPORAL/formula/share/firefoxpwa.json"
if configurar_manifiesto_firefoxpwa "$destino"; then exit 1; fi
[[ ! -e $destino && ! -L $destino ]]
