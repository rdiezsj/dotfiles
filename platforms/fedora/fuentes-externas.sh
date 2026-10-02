#!/usr/bin/env bash

# Configura solo fuentes esenciales; no instala aplicaciones de catálogo.

url_rpm_fusion_valida() {
  [[ $1 == https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-*.noarch.rpm || $1 == https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-*.noarch.rpm ]]
}

rpm_fusion_configurado() {
  rpm -q rpmfusion-free-release rpmfusion-nonfree-release >/dev/null 2>&1
}

url_microsoft_valida() {
  [[ $1 == "https://packages.microsoft.com/config/fedora/${FEDORA_VERSION}/packages-microsoft-prod.rpm" ]]
}

url_firefoxpwa_valida() {
  [[ $1 == https://packagecloud.io/filips/FirefoxPWA/gpgkey ]]
}

configurar_fuentes_catalogo() {
  local directorio_plataforma=$1
  local archivo_compatibilidad=$2
  local version
  local url_microsoft
  # shellcheck source=/dev/null
  source "$archivo_compatibilidad"
  version=$FEDORA_VERSION
  url_microsoft="https://packages.microsoft.com/config/fedora/${version}/packages-microsoft-prod.rpm"
  if ! url_microsoft_valida "$url_microsoft"; then
    printf '%s\n' 'El origen declarado de Microsoft no es válido.' >&2
    return 1
  fi
  if rpm -q packages-microsoft-prod >/dev/null 2>&1; then
    printf '%s\n' 'Repositorio oficial de Microsoft ya está configurado.'
  else
    sudo dnf install -y "$url_microsoft"
  fi

  if ! url_firefoxpwa_valida 'https://packagecloud.io/filips/FirefoxPWA/gpgkey'; then
    printf '%s\n' 'La clave declarada de Firefox PWA no es válida.' >&2
    return 1
  fi
  if [[ ! -f /etc/yum.repos.d/firefoxpwa.repo ]] || ! grep -Fqx 'gpgcheck=1' /etc/yum.repos.d/firefoxpwa.repo; then
    sudo install -Dm0644 "$directorio_plataforma/repos/firefoxpwa.repo" /etc/yum.repos.d/firefoxpwa.repo
    printf '%s\n' 'Repositorio de Firefox PWA configurado con comprobación GPG.'
  else
    printf '%s\n' 'Repositorio de Firefox PWA ya está configurado.'
  fi
}

ruta_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return 0
  fi
  if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    printf '%s\n' /home/linuxbrew/.linuxbrew/bin/brew
    return 0
  fi
  return 1
}

anadir_entorno_homebrew_shell() {
  local shell=$1
  local archivo=$2
  local brew=$3
  local inicio='# >>> dotfiles: Homebrew >>>'
  local fin='# <<< dotfiles: Homebrew <<<'
  local linea
  linea=$(printf 'eval "$(%s shellenv %s)"' "$brew" "$shell")

  if [[ -f $archivo ]] && grep -Fqx "$linea" "$archivo"; then
    printf 'Entorno de Homebrew ya configurado en %s.\n' "$archivo"
    return 0
  fi
  if [[ -f $archivo ]] && grep -Fq 'brew shellenv' "$archivo"; then
    printf 'Entorno de Homebrew ya declarado en %s; no se modifica.\n' "$archivo"
    return 0
  fi
  if [[ -f $archivo ]] && { grep -Fq "$inicio" "$archivo" || grep -Fq "$fin" "$archivo"; }; then
    printf 'Bloque de Homebrew incompleto en %s; no se modifica.\n' "$archivo" >&2
    return 1
  fi

  {
    printf '\n%s\n' "$inicio"
    printf '%s\n' "$linea"
    printf '%s\n' "$fin"
  } >>"$archivo"
  printf 'Entorno de Homebrew añadido a %s.\n' "$archivo"
}

configurar_entorno_homebrew() {
  local brew
  brew=$(ruta_brew) || {
    printf '%s\n' 'No se encontró el ejecutable de Homebrew tras su instalación.' >&2
    return 1
  }

  eval "$("$brew" shellenv bash)"
  anadir_entorno_homebrew_shell bash "$HOME/.bashrc" "$brew"
  anadir_entorno_homebrew_shell zsh "$HOME/.zshrc" "$brew"
}

instalar_dependencias_homebrew() {
  printf '%s\n' 'Preparando herramientas de compilación para Homebrew.'
  sudo dnf group install -y development-tools
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
  if ruta_brew >/dev/null 2>&1; then
    printf '%s\n' 'Homebrew ya está instalado.'
  else
    printf '%s\n' 'Instalando Homebrew desde su instalador oficial.'
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  configurar_entorno_homebrew
  instalar_dependencias_homebrew
}
