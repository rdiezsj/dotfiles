#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/fuentes-externas.sh"

# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/compatibility.env"

url_rpm_fusion_valida 'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-44.noarch.rpm'
url_rpm_fusion_valida 'https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-44.noarch.rpm'
if url_rpm_fusion_valida 'https://ejemplo.invalid/rpmfusion-free-release-44.noarch.rpm'; then
  exit 1
fi
url_repositorio_vscode_valida 'https://packages.microsoft.com/yumrepos/vscode'
url_clave_microsoft_valida 'https://packages.microsoft.com/keys/microsoft.asc'
if url_repositorio_vscode_valida 'https://packages.microsoft.com/yumrepos/code'; then
  exit 1
fi
grep -Fqx 'baseurl=https://packages.microsoft.com/yumrepos/vscode' "$RAIZ/platforms/fedora/repos/vscode.repo"
grep -Fqx 'gpgcheck=1' "$RAIZ/platforms/fedora/repos/vscode.repo"
url_firefoxpwa_valida 'https://packagecloud.io/filips/FirefoxPWA/gpgkey'
grep -Fqx 'repo_gpgcheck=1' "$RAIZ/platforms/fedora/repos/firefoxpwa.repo"
grep -Fqx 'gpgcheck=1' "$RAIZ/platforms/fedora/repos/firefoxpwa.repo"
