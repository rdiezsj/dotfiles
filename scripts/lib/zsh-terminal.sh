#!/usr/bin/env bash

# Enlaza configuración versionada solo después de resolver explícitamente los conflictos.

destino_zsh_gestionado() {
  local raiz=$1
  local destino=$2
  local relativo=${destino#"$HOME"/}
  local origen

  if [[ $relativo == .config/* ]]; then
    origen="$raiz/home/.config/${relativo#.config/}"
  elif [[ $relativo == .codex/* ]]; then
    origen="$raiz/home/.codex/${relativo#.codex/}"
  else
    origen="$raiz/home/$relativo"
  fi

  [[ -L $destino && $(readlink -f "$destino") == $(readlink -f "$origen") ]]
}

listar_destinos_dotbot() {
  cat <<EOF
${HOME}/.nanorc
${HOME}/.vimrc
${HOME}/.gitconfig
${HOME}/.gitignore
${HOME}/.zshrc
${HOME}/.zsh_aliases
${HOME}/.zsh_functions
${HOME}/.profile
${HOME}/.zprofile
${HOME}/.codex/AGENTS.md
${HOME}/.codex/skills/alojamientos-viajes-familiares
${HOME}/.codex/skills/exportar-en-formato-paradigma
${HOME}/.codex/skills/humanizador
${HOME}/.codex/skills/librarium-terra-notes
${HOME}/.codex/skills/planificador-viajes-familiares
${HOME}/.codex/skills/restaurantes-celiacos-seguros
${HOME}/.config/starship.toml
${HOME}/.config/sheldon/plugins.toml
${HOME}/.config/terminator
${HOME}/.local/bin/terminator
${HOME}/.local/share/applications/terminator.desktop
${HOME}/.config/ptyxis/config.dconf
${HOME}/.config/zellij/config.kdl
${HOME}/.config/flameshot/flameshot.ini
${HOME}/.config/Heynote/config.json
${HOME}/.config/Heynote/Preferences
${HOME}/.config/input-remapper-2
${HOME}/.config/msmtp/config
EOF
}

origen_dotfile() {
  local raiz=$1
  local destino=$2
  local relativo=${destino#"$HOME"/}

  if [[ $relativo == .config/* ]]; then
    printf '%s\n' "$raiz/home/.config/${relativo#.config/}"
  elif [[ $relativo == .codex/* ]]; then
    printf '%s\n' "$raiz/home/.codex/${relativo#.codex/}"
  else
    printf '%s\n' "$raiz/home/$relativo"
  fi
}

confirmar_aplicacion_dotfile() {
  local destino=$1
  local origen=$2
  local respuesta

  printf '\nConflicto de Dotbot detectado.\nDestino que se va a sobrescribir: %s\nDotfile versionado: %s\n' "$destino" "$origen" >&2
  if [[ ${DOTFILES_DISABLE_GUM:-false} != true ]] && command -v gum >/dev/null 2>&1; then
    gum confirm "¿Crear un respaldo de $destino y aplicar el dotfile mostrado?"
    return
  fi
  read -r -p '--> ¿Crear respaldo y aplicar este dotfile? [s/N] ' respuesta
  [[ ${respuesta,,} == s || ${respuesta,,} == si || ${respuesta,,} == sí ]]
}

resolver_conflictos_dotbot() {
  local raiz=$1
  local destino origen relativo respaldo
  local -a conflictos=()
  local -a origenes=()

  while IFS= read -r destino; do
    origen=$(origen_dotfile "$raiz" "$destino")
    if [[ ! -e $destino && ! -L $destino ]] || destino_zsh_gestionado "$raiz" "$destino"; then
      continue
    fi
    conflictos+=("$destino")
    origenes+=("$origen")
  done < <(listar_destinos_dotbot)

  for ((indice = 0; indice < ${#conflictos[@]}; indice++)); do
    if ! confirmar_aplicacion_dotfile "${conflictos[indice]}" "${origenes[indice]}"; then
      printf 'Dotbot no modificó ningún archivo: se rechazó el conflicto en %s.\n' "${conflictos[indice]}" >&2
      return 1
    fi
  done

  [[ ${#conflictos[@]} -gt 0 ]] || return 0
  respaldo="$HOME/.dotfiles-backups/dotbot-$(date +%Y%m%d-%H%M%S)"
  for destino in "${conflictos[@]}"; do
    relativo=${destino#"$HOME"/}
    mkdir -p "$respaldo/$(dirname "$relativo")"
    mv "$destino" "$respaldo/$relativo"
    printf 'Respaldo de Dotbot creado: %s\n' "$respaldo/$relativo"
  done
  if declare -F registrar_resultado >/dev/null; then
    registrar_resultado instalados "Dotbot: respaldo recuperable creado en $respaldo"
  fi
}

ejecutar_dotbot_zsh() {
  local raiz=$1
  "$raiz/dotbot/bin/dotbot" -d "$raiz" -c "$raiz/install.conf.yaml"
}

configurar_ptyxis() {
  local configuracion="${XDG_CONFIG_HOME:-$HOME/.config}/ptyxis/config.dconf"
  local uuid='b3a9ca574b7b4bbd9c73a56c3e254ef4'
  local ruta_perfil="/org/gnome/Ptyxis/Profiles/$uuid/"

  if [[ ! -f $configuracion ]]; then
    registrar_resultado fallidos 'Ptyxis: falta ~/.config/ptyxis/config.dconf; resuelve el conflicto de Dotbot y vuelve a ejecutar ./bootstrap'
    return 1
  fi
  if ! command -v dconf >/dev/null 2>&1 || ! command -v gsettings >/dev/null 2>&1; then
    registrar_resultado fallidos 'Ptyxis: faltan dconf o gsettings para aplicar la configuración versionada'
    return 1
  fi
  if ! dconf load /org/gnome/Ptyxis/ <"$configuracion"; then
    registrar_resultado fallidos 'Ptyxis: no se pudo aplicar la configuración versionada'
    return 1
  fi
  if [[ $(gsettings get org.gnome.Ptyxis default-profile-uuid) != "'$uuid'" ]] \
    || [[ $(gsettings get "org.gnome.Ptyxis.Profile:$ruta_perfil" palette) != "'nord'" ]] \
    || [[ $(gsettings get "org.gnome.Ptyxis.Profile:$ruta_perfil" limit-scrollback) != false ]]; then
    registrar_resultado fallidos 'Ptyxis: la configuración aplicada no coincide con el perfil Nord declarado'
    return 1
  fi
  registrar_resultado instalados 'Ptyxis: perfil Nord versionado aplicado y validado'
}

validar_configuracion_zellij() {
  local directorio_configuracion="${XDG_CONFIG_HOME:-$HOME/.config}/zellij"
  local directorio_socket

  if [[ ! -f $directorio_configuracion/config.kdl ]]; then
    registrar_resultado fallidos 'Zellij: falta ~/.config/zellij/config.kdl; resuelve el conflicto de Dotbot y vuelve a ejecutar ./bootstrap'
    return 1
  fi
  if ! command -v zellij >/dev/null 2>&1; then
    registrar_resultado fallidos 'Zellij: no está disponible para validar la configuración versionada'
    return 1
  fi
  directorio_socket=$(mktemp -d) || {
    registrar_resultado fallidos 'Zellij: no se pudo crear el directorio temporal de sockets para validar la configuración'
    return 1
  }
  if ZELLIJ_CONFIG_DIR="$directorio_configuracion" ZELLIJ_SOCKET_DIR="$directorio_socket" zellij setup --check >/dev/null; then
    rm -rf "$directorio_socket"
    registrar_resultado instalados 'Zellij: configuración versionada validada sin autoarranque'
    return 0
  fi
  rm -rf "$directorio_socket"
  registrar_resultado fallidos 'Zellij: la configuración versionada no superó la validación'
  return 1
}

configurar_plugins_sheldon() {
  local perfil
  local directorio_configuracion="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon"
  local directorio_datos="${XDG_DATA_HOME:-$HOME/.local/share}/sheldon"
  local estado_previo=true

  if ! command -v sheldon >/dev/null 2>&1; then
    registrar_resultado fallidos 'Sheldon: no está disponible para materializar los plugins Zsh'
    return 1
  fi
  if [[ ! -f $directorio_configuracion/plugins.toml ]]; then
    registrar_resultado fallidos 'Sheldon: falta ~/.config/sheldon/plugins.toml; resuelve el conflicto de Dotbot y vuelve a ejecutar ./bootstrap'
    return 1
  fi
  if [[ $(grep -Ec '^rev = "[[:xdigit:]]{40}"$' "$directorio_configuracion/plugins.toml") -ne 6 ]]; then
    registrar_resultado fallidos 'Sheldon: la configuración no contiene seis revisiones SHA válidas'
    return 1
  fi

  for perfil in base resaltado; do
    [[ -f $directorio_datos/plugins.$perfil.lock ]] || estado_previo=false
    if ! SHELDON_CONFIG_DIR="$directorio_configuracion" SHELDON_DATA_DIR="$directorio_datos" \
      sheldon --non-interactive --profile "$perfil" lock; then
      registrar_resultado fallidos "Sheldon: no se pudo materializar el perfil $perfil"
      return 1
    fi
  done

  if [[ $estado_previo == true ]]; then
    registrar_resultado presentes 'Sheldon: estado local de plugins ya materializado'
  else
    registrar_resultado instalados 'Sheldon: plugins Zsh materializados en el estado local'
  fi
}

preparar_dotbot_zsh() {
  local raiz=$1
  if [[ -f $raiz/dotbot/lib/pyyaml/lib/yaml/__init__.py ]]; then
    return 0
  fi
  printf '%s\n' 'Inicializando los submódulos fijados de Dotbot.'
  git -C "$raiz" submodule update --init --recursive
}

configurar_archivos_zsh() {
  local raiz=$1
  preparar_dotbot_zsh "$raiz" || return 1
  resolver_conflictos_dotbot "$raiz" || return 1
  if ejecutar_dotbot_zsh "$raiz"; then
    configurar_ptyxis || return 1
    validar_configuracion_zellij || return 1
    configurar_plugins_sheldon || return 1
    if declare -F registrar_resultado >/dev/null; then
      registrar_resultado instalados 'Configuración: archivos versionados enlazados mediante Dotbot'
    fi
    return 0
  fi
  printf '%s\n' 'Dotbot no pudo enlazar los archivos versionados de Zsh.' >&2
  return 1
}

confirmar_cambio_shell_zsh() {
  local respuesta
  if [[ ${DOTFILES_DISABLE_GUM:-false} != true ]] && command -v gum >/dev/null 2>&1; then
    gum confirm '¿Establecer Zsh como shell predeterminada para este usuario?'
    return
  fi
  read -r -p '--> ¿Establecer Zsh como shell predeterminada? [s/N] ' respuesta
  [[ ${respuesta,,} == s || ${respuesta,,} == si || ${respuesta,,} == sí ]]
}

ofrecer_shell_zsh_predeterminada() {
  local zsh_actual usuario shell_actual
  zsh_actual=$(command -v zsh) || {
    registrar_resultado omitidos 'Zsh: no se encontró el ejecutable para cambiar la shell predeterminada'
    return 0
  }
  usuario=$(id -un)
  shell_actual=$(getent passwd "$usuario" | cut -d: -f7)
  if [[ $shell_actual == "$zsh_actual" ]]; then
    registrar_resultado presentes 'Zsh ya es la shell predeterminada'
    return 0
  fi
  if ! confirmar_cambio_shell_zsh; then
    registrar_resultado omitidos 'Zsh: cambio de shell predeterminada rechazado'
    return 0
  fi
  if chsh -s "$zsh_actual" "$usuario"; then
    registrar_resultado instalados 'Zsh establecida como shell predeterminada; se aplicará en la siguiente sesión'
    return 0
  fi
  registrar_resultado fallidos 'Zsh: no se pudo cambiar la shell predeterminada'
  return 1
}

confirmar_recarga_sesion_zsh() {
  local respuesta
  if [[ ${DOTFILES_DISABLE_GUM:-false} != true ]] && command -v gum >/dev/null 2>&1; then
    gum confirm '¿Abrir ahora una nueva sesión Zsh para aplicar la configuración?'
    return
  fi
  read -r -p '--> ¿Abrir ahora una nueva sesión Zsh para aplicar la configuración? [s/N] ' respuesta
  [[ ${respuesta,,} == s || ${respuesta,,} == si || ${respuesta,,} == sí ]]
}

terminal_actual_usa_zsh() {
  local proceso_padre
  proceso_padre=$(ps -p "$PPID" -o comm= 2>/dev/null) || return 1
  proceso_padre=${proceso_padre//[[:space:]]/}
  [[ ${proceso_padre##*/} == zsh ]]
}

ofrecer_recarga_sesion_zsh() {
  local zsh_actual
  zsh_actual=$(command -v zsh) || {
    printf '%s\n' 'No se encontró Zsh; se mantiene la sesión actual.' >&2
    return 0
  }
  if terminal_actual_usa_zsh; then
    printf '%s\n' 'La sesión actual ya usa Zsh; no se abre una sesión adicional.'
    return 0
  fi
  if ! confirmar_recarga_sesion_zsh; then
    printf '%s\n' 'Se mantiene la sesión actual; abre una nueva terminal para aplicar Zsh.'
    return 0
  fi
  printf '%s\n' 'Abriendo una nueva sesión Zsh de inicio de sesión.'
  exec "$zsh_actual" -l
}
