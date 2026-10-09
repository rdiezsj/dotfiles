#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
flujo="$RAIZ/.github/workflows/validar-repositorio.yml"

grep -Fqx '      - name: Instalar dependencias del sistema de validación' "$flujo"
for paquete in jq p7zip-full tar unzip util-linux xz-utils zip zsh; do
  grep -Fq "            $paquete" "$flujo"
done

grep -Fq 'for comando in git jq zsh 7z tar unzip zip xz script pre-commit' "$RAIZ/scripts/check.sh"
