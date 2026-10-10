# Reutiliza una sesión válida sin solicitar contraseñas al abrir la terminal.
_dotfiles_recuperar_sesion_vaultwarden() {
  emulate -L zsh
  local sesion
  command -v secret-tool >/dev/null 2>&1 || return 0
  command -v bw >/dev/null 2>&1 || return 0
  sesion=$(secret-tool lookup service dotfiles-vaultwarden account "$USER" 2>/dev/null) || return 0
  [[ -n $sesion ]] || return 0
  if BW_SESSION="$sesion" bw list folders --raw >/dev/null 2>&1; then
    export BW_SESSION="$sesion"
  fi
  return 0
}

_dotfiles_recuperar_sesion_vaultwarden
unfunction _dotfiles_recuperar_sesion_vaultwarden
