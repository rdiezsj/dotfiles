#!/usr/bin/env bash

# Crea el scaffold personal y las plantillas de Nautilus sin sobrescribirlas.

configurar_identidad_git() {
  local archivo="$HOME/.gitconfig.local" nombre correo
  if [[ -e $archivo ]]; then
    if git config --file "$archivo" user.name >/dev/null && git config --file "$archivo" user.email >/dev/null; then
      printf '%s\n' 'Identidad Git local ya configurada.'
      return 0
    fi
    printf '%s\n' 'La identidad Git local está incompleta; revisa ~/.gitconfig.local sin sobrescribirla.' >&2
    return 1
  fi
  nombre=$(git config --global --includes user.name || true)
  correo=$(git config --global --includes user.email || true)
  if [[ -z $nombre ]]; then
    read -r -p 'Nombre para los commits Git (vacío para omitir): ' nombre || nombre=
  fi
  if [[ -z $nombre ]]; then
    printf '%s\n' 'Configuración de identidad Git omitida.'
    return 0
  fi
  if [[ -z $correo ]]; then
    read -r -p 'Correo para los commits Git (puedes usar noreply de GitHub; vacío para omitir): ' correo || correo=
  fi
  if [[ -z $correo ]]; then
    printf '%s\n' 'Configuración de identidad Git omitida.'
    return 0
  fi
  (umask 077
   git config --file "$archivo" user.name "$nombre" &&
   git config --file "$archivo" user.email "$correo") || return 1
  printf '%s\n' 'Identidad Git guardada solo en ~/.gitconfig.local.'
}

directorio_plantillas_nautilus() {
  if [[ -n ${DOTFILES_TEMPLATES_DIR:-} ]]; then
    printf '%s\n' "$DOTFILES_TEMPLATES_DIR"
    return
  fi
  if command -v xdg-user-dir >/dev/null 2>&1; then
    local directorio
    directorio=$(xdg-user-dir TEMPLATES)
    if [[ $directorio != "$HOME" ]]; then
      printf '%s\n' "$directorio"
      return
    fi
  fi
  printf '%s\n' "${HOME}/Plantillas"
}

crear_scaffold_personal() {
  local catalogo=$1
  # shellcheck source=/dev/null
  source "$catalogo"
  local carpeta
  for carpeta in "${CARPETAS_PERSONALES[@]}"; do
    mkdir -p "$HOME/$carpeta"
  done
}

instalar_plantillas_nautilus() {
  local origen=$1
  local destino
  destino=$(directorio_plantillas_nautilus)
  mkdir -p "$destino"
  local plantilla nombre destino_plantilla
  for plantilla in "$origen"/*; do
    nombre=$(basename "$plantilla")
    destino_plantilla="$destino/$nombre"
    if [[ -e $destino_plantilla ]]; then
      if cmp -s "$plantilla" "$destino_plantilla"; then
        printf 'Plantilla ya presente: %s\n' "$nombre"
        continue
      fi
      printf 'Conflicto de plantilla no gestionada: %s\n' "$destino_plantilla" >&2
      return 1
    fi
    install -m 0644 "$plantilla" "$destino_plantilla"
  done
}
