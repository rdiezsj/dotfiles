#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
DIRECTORIO_TEMPORAL=$(mktemp -d)
trap 'rm -rf "$DIRECTORIO_TEMPORAL"' EXIT

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/validar-entorno-fedora.sh"

cat >"$DIRECTORIO_TEMPORAL/fedora-workstation" <<'EOF'
ID=fedora
VERSION_ID="44"
VARIANT_ID=workstation
EOF

validar_entorno_fedora "$RAIZ/platforms/fedora/compatibility.env" "$DIRECTORIO_TEMPORAL/fedora-workstation" GNOME >/dev/null

cat >"$DIRECTORIO_TEMPORAL/fedora-incorrecta" <<'EOF'
ID=fedora
VERSION_ID="45"
VARIANT_ID=workstation
EOF

if validar_entorno_fedora "$RAIZ/platforms/fedora/compatibility.env" "$DIRECTORIO_TEMPORAL/fedora-incorrecta" GNOME >/dev/null 2>&1; then
  printf 'La versión incompatible no se rechazó.\n' >&2
  exit 1
fi

if validar_entorno_fedora "$RAIZ/platforms/fedora/compatibility.env" "$DIRECTORIO_TEMPORAL/fedora-workstation" KDE >/dev/null 2>&1; then
  printf 'La sesión no GNOME no se rechazó.\n' >&2
  exit 1
fi
