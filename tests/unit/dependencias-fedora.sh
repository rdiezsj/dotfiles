#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/dependencias.sh"

dependencia_disponible() {
  [[ $1 == git || $1 == curl ]]
}

resultado=$(dependencias_ausentes)
[[ $resultado == $'zsh\nflatpak\ngum\npython3\nlibsecret\npciutils\nmokutil' ]]
