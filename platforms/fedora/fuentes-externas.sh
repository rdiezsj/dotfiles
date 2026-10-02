#!/usr/bin/env bash

# Configura solo fuentes esenciales; no instala aplicaciones de catálogo.

url_rpm_fusion_valida() {
  [[ $1 == https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-*.noarch.rpm || $1 == https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-*.noarch.rpm ]]
}

rpm_fusion_configurado() {
  rpm -q rpmfusion-free-release rpmfusion-nonfree-release >/dev/null 2>&1
}

configurar_rpm_fusion() {
  local catalogo=$1
  # shellcheck source=/dev/null
  source "$catalogo"
  if ! url_rpm_fusion_valida "$RPM_FUSION_FREE_URL" || ! url_rpm_fusion_valida "$RPM_FUSION_NONFREE_URL"; then
    printf '%s\n' 'El origen declarado de RPM Fusion no es válido.' >&2
    return 1
  fi
  if rpm_fusion_configurado; then
    printf '%s\n' 'RPM Fusion Free y Nonfree ya están configurados.'
    return 0
  fi
  sudo dnf install -y "$RPM_FUSION_FREE_URL" "$RPM_FUSION_NONFREE_URL"
}

instalar_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    printf '%s\n' 'Homebrew ya está instalado.'
    return 0
  fi
  printf '%s\n' 'Instalando Homebrew desde su instalador oficial.'
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
