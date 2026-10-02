#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

cat >"$TEMPORAL/os-release" <<'EOF'
ID=fedora
VERSION_ID="44"
VARIANT_ID=workstation
EOF

salida=$(DOTFILES_DISABLE_GUM=true DOTFILES_OS_RELEASE="$TEMPORAL/os-release" DOTFILES_DESKTOP=GNOME "$RAIZ/bootstrap" --dry-run)
[[ $salida == *'Plan completo:'* ]]
[[ $salida == *'Simulación completada: no se ha modificado el equipo.'* ]]
[[ $salida == *'Resumen final:'* ]]
[[ $salida == *'Omitidos:'* ]]
