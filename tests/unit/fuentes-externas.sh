#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/fuentes-externas.sh"

url_rpm_fusion_valida 'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-44.noarch.rpm'
url_rpm_fusion_valida 'https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-44.noarch.rpm'
if url_rpm_fusion_valida 'https://ejemplo.invalid/rpmfusion-free-release-44.noarch.rpm'; then
  exit 1
fi
