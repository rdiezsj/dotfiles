#!/usr/bin/env bash
set -euo pipefail
RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
python3 "$RAIZ/tests/unit/teclas-zsh.py" "$RAIZ"
