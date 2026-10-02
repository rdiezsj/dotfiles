#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
for catalogo in dnf-rpm flatpak homebrew appimage; do
  archivo="$RAIZ/catalogs/$catalogo.sh"
  test -f "$archivo"
  grep -q '^# ' "$archivo"
  bash -n "$archivo"
done
