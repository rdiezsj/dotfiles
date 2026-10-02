#!/usr/bin/env bash

# Crea el scaffold personal y las plantillas de Nautilus sin sobrescribirlas.

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
