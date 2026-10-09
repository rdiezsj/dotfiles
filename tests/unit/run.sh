#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
for prueba in "$RAIZ"/tests/unit/*.sh; do
  [[ $(basename "$prueba") == run.sh ]] && continue
  if ! bash "$prueba"; then
    printf 'Prueba unitaria fallida: %s\n' "$(basename "$prueba")" >&2
    exit 1
  fi
done
