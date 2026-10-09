#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
for archivo in "$RAIZ"/bootstrap "$RAIZ"/catalogs/*.sh "$RAIZ"/platforms/fedora/*.sh "$RAIZ"/scripts/*.sh "$RAIZ"/scripts/lib/*.sh; do
  bash -n "$archivo"
done
bash "$RAIZ/tests/unit/run.sh"
bash "$RAIZ/tests/unit/documentacion.sh"
