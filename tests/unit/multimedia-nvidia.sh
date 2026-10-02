#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
cat >"$TEMPORAL/compatibility.env" <<'EOF'
FEDORA_VERSION=44
EOF

# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/multimedia-nvidia.sh"
# shellcheck source=/dev/null
source "$TEMPORAL/compatibility.env"

url_rpm_fusion_tainted_valida 'https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-tainted-44.noarch.rpm'
if url_rpm_fusion_tainted_valida 'https://example.invalid/tainted.rpm'; then
  exit 1
fi

registro=$(mktemp)
registrar_resultado() { printf '%s:%s\n' "$1" "$2" >>"$registro"; }
sudo() {
  [[ $1 == dnf && $2 == install && $3 == -y ]] || return 1
  [[ $4 == akmod-nvidia ]]
  [[ $5 == xorg-x11-drv-nvidia-cuda ]]
  [[ $6 == libva-nvidia-driver ]]
  [[ $7 == libva-nvidia-driver.i686 ]]
  [[ $8 == xorg-x11-drv-nvidia-libs.i686 ]]
}
lspci() { printf '01:00.0 VGA compatible controller [0300]: NVIDIA RTX 4060 Ti [10de:2803]\n'; }
mokutil() { printf 'SecureBoot enabled\n'; }
instalar_nvidia
grep -Fqx 'pendientes:NVIDIA: Secure Boot activo; enrola la clave MOK y reinicia antes de validar el controlador' "$registro"

: >"$registro"
lspci() { printf '00:02.0 VGA compatible controller [0300]: Intel Corporation\n'; }
instalar_nvidia
grep -Fqx 'omitidos:NVIDIA: no se detectó una GPU NVIDIA; no se modificó el controlador gráfico' "$registro"
