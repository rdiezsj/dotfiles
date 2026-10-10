#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
PYTHONDONTWRITEBYTECODE=1 python3 "$RAIZ/tests/unit/doctor.py"
