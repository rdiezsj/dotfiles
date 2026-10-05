#!/usr/bin/env bash

# Migra la configuración de inicio de Zsh sin reemplazar contenido sin respaldo.

destino_zsh_gestionado() {
  local raiz=$1
  local destino=$2
  local relativo=${destino#"$HOME"/}
  local origen

  if [[ $relativo == .config/starship.toml ]]; then
    origen="$raiz/home/config/starship.toml"
  else
    origen="$raiz/home/$relativo"
  fi

  [[ -L $destino && $(readlink -f "$destino") == $(readlink -f "$origen") ]]
}

preparar_migracion_zsh() {
  local raiz=$1
  local destino relativo
  local -a destinos=("$HOME/.zshrc" "$HOME/.zsh_aliases" "$HOME/.profile" "$HOME/.zprofile" "$HOME/.config/starship.toml")

  for destino in "${destinos[@]}"; do
    if [[ -e $destino || -L $destino ]]; then
      if destino_zsh_gestionado "$raiz" "$destino"; then
        continue
      fi
      if [[ -d $destino ]]; then
        printf 'Conflicto de Zsh: %s es un directorio y no se puede migrar.\n' "$destino" >&2
        return 1
      fi
    fi
  done

  local respaldo="$HOME/.dotfiles-backups/zsh-$(date +%Y%m%d-%H%M%S)"
  local creo_respaldo=false
  for destino in "${destinos[@]}"; do
    if [[ -e $destino || -L $destino ]] && ! destino_zsh_gestionado "$raiz" "$destino"; then
      relativo=${destino#"$HOME"/}
      mkdir -p "$respaldo/$(dirname "$relativo")"
      mv "$destino" "$respaldo/$relativo"
      printf 'Respaldo de Zsh creado: %s\n' "$respaldo/$relativo"
      creo_respaldo=true
    fi
  done
  if [[ $creo_respaldo == true ]] && declare -F registrar_resultado >/dev/null; then
    registrar_resultado instalados "Zsh: respaldo recuperable creado en $respaldo"
  fi
}

ejecutar_dotbot_zsh() {
  local raiz=$1
  "$raiz/dotbot/bin/dotbot" -d "$raiz" -c "$raiz/install.conf.yaml"
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
  preparar_migracion_zsh "$raiz" || return 1
  if ejecutar_dotbot_zsh "$raiz"; then
    if declare -F registrar_resultado >/dev/null; then
      registrar_resultado instalados 'Zsh: archivos versionados enlazados mediante Dotbot'
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
