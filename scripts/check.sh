#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
for comando in git jq zsh 7z tar unzip zip xz script pre-commit; do
  if ! command -v "$comando" >/dev/null 2>&1; then
    printf 'Falta la dependencia de validación: %s\n' "$comando" >&2
    exit 1
  fi
done

for archivo in "$RAIZ"/bootstrap "$RAIZ"/catalogs/*.sh "$RAIZ"/platforms/fedora/*.sh "$RAIZ"/scripts/*.sh "$RAIZ"/scripts/lib/*.sh; do
  bash -n "$archivo"
done
bash "$RAIZ/tests/unit/run.sh"
bash "$RAIZ/tests/unit/documentacion.sh"
