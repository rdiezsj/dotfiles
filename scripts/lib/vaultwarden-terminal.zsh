# Recupera la sesión al usar Bitwarden, sin retrasar el prompt.
bw() {
  emulate -L zsh
  local sesion
  if [[ -z ${BW_SESSION:-} ]] && command -v secret-tool >/dev/null 2>&1; then
    sesion=$(secret-tool lookup service dotfiles-vaultwarden account "$USER" 2>/dev/null) || sesion=
    if [[ -n $sesion ]]; then
      BW_SESSION="$sesion" command bw "$@"
      return $?
    fi
  fi
  command bw "$@"
}
