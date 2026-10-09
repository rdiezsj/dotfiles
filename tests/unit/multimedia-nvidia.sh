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

paquete_rpm_fusion_tainted_valido rpmfusion-free-release-tainted
if paquete_rpm_fusion_tainted_valido rpmfusion-free-release-tainted-no-declarado; then
  exit 1
fi

registro=$(mktemp)
registrar_resultado() { printf '%s:%s\n' "$1" "$2" >>"$registro"; }
operaciones="$TEMPORAL/operaciones"
nvidia_paquete_ausente='*'
modulo_nvidia=false
nvidia_smi=false
resultado_akmods=0
rpm() {
  if [[ $1 == -q ]]; then
    case $2 in
      akmod-nvidia|xorg-x11-drv-nvidia-cuda|libva-nvidia-driver|libva-nvidia-driver.i686|xorg-x11-drv-nvidia-libs.i686)
        [[ $nvidia_paquete_ausente != '*' && $2 != "$nvidia_paquete_ausente" ]]
        return
        ;;
    esac
  fi
  return 1
}
sudo() {
  printf '%s\n' "$*" >>"$operaciones"
  if [[ $1 == dnf && $2 == install && $3 == -y ]]; then
    nvidia_paquete_ausente=
    return 0
  fi
  if [[ $1 == timeout && $2 == 300 && $3 == akmods && $4 == --force && $5 == --kernels ]]; then
    if (( resultado_akmods == 0 )); then
      modulo_nvidia=true
    fi
    return "$resultado_akmods"
  fi
  return 1
}
lspci() { printf '01:00.0 VGA compatible controller [0300]: NVIDIA RTX 4060 Ti [10de:2803]\n'; }
mokutil() { printf 'SecureBoot enabled\n'; }
akmods() { :; }
uname() { printf '%s\n' '6.17.0-test'; }
modinfo() { [[ $modulo_nvidia == true ]]; }
nvidia-smi() { [[ $nvidia_smi == true ]]; }
instalar_nvidia
grep -Fqx 'dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda libva-nvidia-driver libva-nvidia-driver.i686 xorg-x11-drv-nvidia-libs.i686' "$operaciones"
grep -Fqx 'timeout 300 akmods --force --kernels 6.17.0-test' "$operaciones"
grep -Fqx 'pendientes:NVIDIA: Secure Boot activo; enrola la clave MOK, reinicia manualmente y ejecuta manualmente ./bootstrap para validar el controlador' "$registro"

: >"$registro"
: >"$operaciones"
nvidia_paquete_ausente=libva-nvidia-driver.i686
modulo_nvidia=true
nvidia_smi=true
instalar_nvidia
grep -Fqx 'dnf install -y libva-nvidia-driver.i686' "$operaciones"
grep -Fqx 'instalados:NVIDIA: controlador propietario RPM Fusion instalado y verificado' "$registro"

: >"$registro"
: >"$operaciones"
nvidia_paquete_ausente=
modulo_nvidia=true
nvidia_smi=true
instalar_nvidia
[[ ! -s $operaciones ]]
grep -Fqx 'presentes:NVIDIA: controlador propietario RPM Fusion ya estaba verificado' "$registro"

: >"$registro"
: >"$operaciones"
nvidia_paquete_ausente=
modulo_nvidia=false
nvidia_smi=false
resultado_akmods=124
if instalar_nvidia; then
  exit 1
fi
grep -Fqx 'fallidos:NVIDIA: akmods agotó el tiempo de compilación para el kernel activo' "$registro"

: >"$registro"
: >"$operaciones"
resultado_akmods=1
sudo() {
  printf '%s\n' "$*" >>"$operaciones"
  return 1
}
if instalar_nvidia; then
  exit 1
fi
grep -Fqx 'fallidos:NVIDIA: akmods no pudo preparar el módulo para el kernel activo' "$registro"

: >"$registro"
lspci() { printf '00:02.0 VGA compatible controller [0300]: Intel Corporation\n'; }
instalar_nvidia
grep -Fqx 'omitidos:NVIDIA: no se detectó una GPU NVIDIA; no se modificó el controlador gráfico' "$registro"

: >"$registro"
operaciones="$TEMPORAL/operaciones"
rpm() {
  [[ $1 == -q && $2 == ffmpeg ]] && return 0
  return 1
}
sudo() {
  printf '%s\n' "$*" >>"$operaciones"
}
configurar_multimedia
grep -Fqx 'dnf install -y rpmfusion-free-release-tainted' "$operaciones"
grep -Fqx 'dnf install -y libavcodec-freeworld libdvdcss' "$operaciones"
grep -Fqx 'instalados:Multimedia: codecs y soporte DVD comprobados' "$registro"
