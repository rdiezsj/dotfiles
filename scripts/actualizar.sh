#!/usr/bin/env bash

set -uo pipefail

RAIZ=${DOTFILES_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/resumen-bootstrap.sh"
# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/actualizar-estacion.sh"

ejecutar_actualizacion_estacion "$RAIZ"
