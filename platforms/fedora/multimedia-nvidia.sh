#!/usr/bin/env bash

# Configura multimedia RPM Fusion y NVIDIA solo cuando el hardware lo requiere.

registrar_multimedia() {
  local categoria=$1
  local mensaje=$2
  if declare -F registrar_resultado >/dev/null; then
    registrar_resultado "$categoria" "$mensaje"
  else
    printf '[%s] %s\n' "$categoria" "$mensaje"
  fi
}

paquete_rpm_fusion_tainted_valido() {
  [[ $1 == rpmfusion-free-release-tainted ]]
}

configurar_rpm_fusion_tainted() {
  local paquete=rpmfusion-free-release-tainted
  if ! paquete_rpm_fusion_tainted_valido "$paquete"; then
    printf '%s\n' 'El paquete RPM Fusion tainted para DVD no es válido.' >&2
    return 1
  fi
  if rpm -q rpmfusion-free-release-tainted >/dev/null 2>&1; then
    return 0
  fi
  sudo dnf install -y "$paquete"
}

configurar_multimedia() {
  local dvd_disponible=true
  if ! configurar_rpm_fusion_tainted; then
    dvd_disponible=false
    registrar_multimedia pendientes 'Multimedia: soporte DVD pendiente; no se pudo habilitar RPM Fusion tainted'
  fi
  if rpm -q ffmpeg-free >/dev/null 2>&1; then
    sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
    registrar_multimedia instalados 'Multimedia: FFmpeg completo sustituye a ffmpeg-free'
  elif rpm -q ffmpeg >/dev/null 2>&1; then
    registrar_multimedia presentes 'Multimedia: FFmpeg completo ya estaba instalado'
  else
    sudo dnf install -y ffmpeg
    registrar_multimedia instalados 'Multimedia: FFmpeg completo instalado'
  fi
  sudo dnf group upgrade -y multimedia --setopt=install_weak_deps=False
  if [[ $dvd_disponible == true ]]; then
    if sudo dnf install -y libavcodec-freeworld libdvdcss; then
      registrar_multimedia instalados 'Multimedia: codecs y soporte DVD comprobados'
    else
      registrar_multimedia fallidos 'Multimedia: no se pudieron instalar los codecs y el soporte DVD'
    fi
  elif sudo dnf install -y libavcodec-freeworld; then
    registrar_multimedia instalados 'Multimedia: codecs instalados; soporte DVD pendiente'
  else
    registrar_multimedia fallidos 'Multimedia: no se pudieron instalar los codecs'
  fi
}

PAQUETES_NVIDIA=(
  akmod-nvidia
  xorg-x11-drv-nvidia-cuda
  libva-nvidia-driver
  libva-nvidia-driver.i686
  xorg-x11-drv-nvidia-libs.i686
)

equipo_tiene_nvidia() {
  lspci -nn 2>/dev/null | grep -qi '\[10de:'
}

secure_boot_activo() {
  mokutil --sb-state 2>/dev/null | grep -qi 'enabled'
}

kernel_activo() {
  uname -r
}

paquetes_nvidia_faltantes() {
  local paquete
  for paquete in "${PAQUETES_NVIDIA[@]}"; do
    if ! rpm -q "$paquete" >/dev/null 2>&1; then
      printf '%s\n' "$paquete"
    fi
  done
}

modulo_nvidia_disponible() {
  modinfo -k "$(kernel_activo)" nvidia >/dev/null 2>&1
}

nvidia_smi_operativo() {
  command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi >/dev/null 2>&1
}

compilar_modulo_nvidia() {
  if ! command -v akmods >/dev/null 2>&1; then
    printf '%s\n' 'No se encontró akmods tras instalar el controlador NVIDIA.' >&2
    return 1
  fi
  sudo timeout 300 akmods --force --kernels "$(kernel_activo)"
}

instalar_nvidia() {
  local -a paquetes_faltantes=()
  local cambio_realizado=false

  if ! equipo_tiene_nvidia; then
    registrar_multimedia omitidos 'NVIDIA: no se detectó una GPU NVIDIA; no se modificó el controlador gráfico'
    return 0
  fi

  mapfile -t paquetes_faltantes < <(paquetes_nvidia_faltantes)
  if (( ${#paquetes_faltantes[@]} > 0 )); then
    sudo dnf install -y "${paquetes_faltantes[@]}"
    cambio_realizado=true
  fi

  if ! modulo_nvidia_disponible; then
    if compilar_modulo_nvidia; then
      :
    else
      local codigo_akmods=$?
      if (( codigo_akmods == 124 )); then
        registrar_multimedia fallidos 'NVIDIA: akmods agotó el tiempo de compilación para el kernel activo'
      else
        registrar_multimedia fallidos 'NVIDIA: akmods no pudo preparar el módulo para el kernel activo'
      fi
      return 1
    fi
    if ! modulo_nvidia_disponible; then
      registrar_multimedia fallidos 'NVIDIA: akmods no pudo preparar el módulo para el kernel activo'
      return 1
    fi
    cambio_realizado=true
  fi

  if nvidia_smi_operativo; then
    if [[ $cambio_realizado == true ]]; then
      registrar_multimedia instalados 'NVIDIA: controlador propietario RPM Fusion instalado y verificado'
    else
      registrar_multimedia presentes 'NVIDIA: controlador propietario RPM Fusion ya estaba verificado'
    fi
    return 0
  fi

  if secure_boot_activo; then
    registrar_multimedia pendientes 'NVIDIA: Secure Boot activo; enrola la clave MOK, reinicia manualmente y ejecuta manualmente ./bootstrap para validar el controlador'
  else
    registrar_multimedia pendientes 'NVIDIA: reinicia manualmente y ejecuta manualmente ./bootstrap para validar el controlador'
  fi
}

configurar_multimedia_y_nvidia() {
  configurar_multimedia
  instalar_nvidia
}
