#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/conflictos-dotbot.sh"

touch "$TEMPORAL/origen" "$TEMPORAL/destino-no-gestionado"
if verificar_destino_dotbot "$TEMPORAL/origen" "$TEMPORAL/destino-no-gestionado" >/dev/null 2>&1; then
  printf 'El conflicto no gestionado no se detuvo.\n' >&2
  exit 1
fi

ln -s "$TEMPORAL/origen" "$TEMPORAL/destino-gestionado"
verificar_destino_dotbot "$TEMPORAL/origen" "$TEMPORAL/destino-gestionado"
