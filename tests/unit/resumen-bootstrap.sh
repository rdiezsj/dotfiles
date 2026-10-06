#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
registro="$TEMPORAL/gum.log"

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/resumen-bootstrap.sh"

gum() {
  printf '%s\n' "$*" >>"$registro"
}

registrar_resultado instalados 'Elemento de prueba'
mostrar_resumen_final

grep -Fqx 'style --border double --padding 0 1 --foreground 212 DOTFILES FEDORA -- RESUMEN FINAL' "$registro"
grep -Fqx 'style --foreground 212 --bold Instalados:' "$registro"

registrar_resultado pendientes 'NVIDIA: reinicia manualmente y ejecuta manualmente ./bootstrap para validar el controlador'
salida=$(mostrar_resumen_final)
[[ $salida == *'NVIDIA: reinicia manualmente y ejecuta manualmente ./bootstrap para validar el controlador'* ]]
