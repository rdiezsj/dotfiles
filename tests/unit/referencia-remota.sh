#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

ORIGEN="$TEMPORAL/origen"
DESTINO="$TEMPORAL/dotfiles"
OS_RELEASE="$TEMPORAL/os-release"

mkdir -p "$ORIGEN/scripts/lib" "$ORIGEN/platforms/fedora"
cp "$RAIZ/scripts/lib/validar-entorno-fedora.sh" "$ORIGEN/scripts/lib/"
cp "$RAIZ/platforms/fedora/compatibility.env" "$ORIGEN/platforms/fedora/"
git -C "$ORIGEN" init --quiet --initial-branch fedora-44
git -C "$ORIGEN" add .
git -C "$ORIGEN" -c user.name=Prueba -c user.email=prueba@example.invalid commit --quiet -m 'Referencia Fedora 44'

cat >"$OS_RELEASE" <<'EOF'
ID=fedora
VERSION_ID="45"
VARIANT_ID=workstation
EOF

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/referencia-remota.sh"

if clonar_referencia_validada "$ORIGEN" fedora-44 "$DESTINO" "$OS_RELEASE" GNOME >/dev/null 2>&1; then
  printf 'Una referencia incompatible no se rechazó.\n' >&2
  exit 1
fi

if [[ -e $DESTINO ]]; then
  printf 'El destino se modificó pese a la incompatibilidad.\n' >&2
  exit 1
fi
