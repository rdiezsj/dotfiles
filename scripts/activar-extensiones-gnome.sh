#!/usr/bin/env bash

set -uo pipefail

RAIZ=${DOTFILES_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/resumen-bootstrap.sh"
# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/extensiones-gnome.sh"

if ejecutar_activacion_extensiones_gnome; then
  estado=0
else
  estado=1
fi
mostrar_resumen_final
exit "$estado"
