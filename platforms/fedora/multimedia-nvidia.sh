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

equipo_tiene_nvidia() {
  lspci -nn 2>/dev/null | grep -qi '\[10de:'
}

secure_boot_activo() {
  mokutil --sb-state 2>/dev/null | grep -qi 'enabled'
}

instalar_nvidia() {
  if ! equipo_tiene_nvidia; then
    registrar_multimedia omitidos 'NVIDIA: no se detectó una GPU NVIDIA; no se modificó el controlador gráfico'
    return 0
  fi
  sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda libva-nvidia-driver libva-nvidia-driver.i686 xorg-x11-drv-nvidia-libs.i686
  if secure_boot_activo; then
    registrar_multimedia pendientes 'NVIDIA: Secure Boot activo; enrola la clave MOK y reinicia antes de validar el controlador'
  else
    registrar_multimedia pendientes 'NVIDIA: akmods puede seguir compilando; reinicia y valida nvidia-smi antes de considerar operativo el controlador'
  fi
}

configurar_multimedia_y_nvidia() {
  configurar_multimedia
  instalar_nvidia
}
