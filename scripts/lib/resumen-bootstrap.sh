#!/usr/bin/env bash

# Agrupa resultados sin guardar ni mostrar valores sensibles.

declare -a RESULTADOS_INSTALADOS=()
declare -a RESULTADOS_PRESENTES=()
declare -a RESULTADOS_OMITIDOS=()
declare -a RESULTADOS_FALLIDOS=()
declare -a RESULTADOS_PENDIENTES=()

registrar_resultado() {
  local categoria=$1
  local elemento=$2

  case $categoria in
    instalados) RESULTADOS_INSTALADOS+=("$elemento") ;;
    presentes) RESULTADOS_PRESENTES+=("$elemento") ;;
    omitidos) RESULTADOS_OMITIDOS+=("$elemento") ;;
    fallidos) RESULTADOS_FALLIDOS+=("$elemento") ;;
    pendientes) RESULTADOS_PENDIENTES+=("$elemento") ;;
    *)
      printf 'Categoría de resultado desconocida: %s\n' "$categoria" >&2
      return 1
      ;;
  esac
}

mostrar_categoria() {
  local titulo=$1
  shift
  if [[ ${DOTFILES_DISABLE_GUM:-false} != true ]] && command -v gum >/dev/null 2>&1; then
    gum style --foreground 212 --bold "$titulo"
  else
    printf '%s\n' "$titulo"
  fi
  if (( $# == 0 )); then
    printf '%s\n' '- Ninguno.'
    return
  fi
  local elemento
  for elemento in "$@"; do
    printf '%s\n' "  - $elemento"
  done
}

mostrar_resumen_final() {
  if [[ ${DOTFILES_DISABLE_GUM:-false} != true ]] && command -v gum >/dev/null 2>&1; then
    gum style --border double --padding '0 1' --foreground 212 'DOTFILES FEDORA -- RESUMEN FINAL'
  else
    printf '\n+----------------------------------------+\n'
    printf '%s\n' '| RESUMEN FINAL                          |'
    printf '%s\n' '+----------------------------------------+'
  fi
  mostrar_categoria 'Instalados:' "${RESULTADOS_INSTALADOS[@]}"
  mostrar_categoria 'Ya presentes:' "${RESULTADOS_PRESENTES[@]}"
  mostrar_categoria 'Omitidos:' "${RESULTADOS_OMITIDOS[@]}"
  mostrar_categoria 'Fallidos:' "${RESULTADOS_FALLIDOS[@]}"
  mostrar_categoria 'Acciones manuales pendientes:' "${RESULTADOS_PENDIENTES[@]}"
}
