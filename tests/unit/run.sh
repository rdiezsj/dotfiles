#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
for prueba in "$RAIZ"/tests/unit/*.sh; do
  [[ $(basename "$prueba") == run.sh ]] || bash "$prueba"
done
