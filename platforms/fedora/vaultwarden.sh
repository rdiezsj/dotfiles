#!/usr/bin/env bash

# La configuración de Vaultwarden es opcional y nunca bloquea el bootstrap base.

SERVICIO_SESION_VAULTWARDEN=dotfiles-vaultwarden

preparar_bitwarden_cli() {
  if command -v bw >/dev/null 2>&1; then
    return 0
  fi
  if ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' 'Homebrew no está disponible; no se puede instalar Bitwarden CLI.' >&2
    return 1
  fi
  printf '%s\n' 'Instalando Bitwarden CLI mediante Homebrew.'
  brew install bitwarden-cli
}

guardar_sesion_vaultwarden() {
  local sesion=$1
  secret-tool store --label='Sesión de Vaultwarden para dotfiles' service "$SERVICIO_SESION_VAULTWARDEN" account "$USER" <<<"$sesion"
}

obtener_sesion_vaultwarden() {
  secret-tool lookup service "$SERVICIO_SESION_VAULTWARDEN" account "$USER"
}

validar_sesion_vaultwarden() {
  local sesion
  sesion=$(obtener_sesion_vaultwarden) || return 1
  [[ -n $sesion ]] && BW_SESSION="$sesion" bw list folders --raw >/dev/null
}

iniciar_sesion_vaultwarden() {
  preparar_bitwarden_cli
  bw login
  local sesion
  sesion=$(bw unlock --raw)
  guardar_sesion_vaultwarden "$sesion"
  if ! validar_sesion_vaultwarden; then
    printf '%s\n' 'La sesión de Vaultwarden no pudo validarse.' >&2
    return 1
  fi
  printf '%s\n' 'Sesión de Vaultwarden almacenada en GNOME Keyring.'
}

configurar_vaultwarden() {
  local servidor=${1:-}
  if ! preparar_bitwarden_cli; then
    printf '%s\n' 'Bitwarden CLI no está disponible; Vaultwarden queda pendiente.' >&2
    return 1
  fi
  if [[ -z $servidor ]]; then
    read -r -p 'URL de Vaultwarden (vacía para omitir): ' servidor
  fi
  if [[ -z $servidor ]]; then
    printf '%s\n' 'Configuración de Vaultwarden omitida.'
    return 2
  fi
  bw config server "$servidor"
  iniciar_sesion_vaultwarden
}
