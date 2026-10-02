#!/usr/bin/env bash

# Detecta destinos que Dotbot no puede gestionar sin intervención humana.

verificar_destino_dotbot() {
  local origen=$1
  local destino=$2
  if [[ ! -e $destino && ! -L $destino ]]; then
    return 0
  fi
  if [[ -L $destino && $(readlink -f "$destino") == $(readlink -f "$origen") ]]; then
    return 0
  fi
  printf 'Conflicto de Dotbot: %s no está gestionado para %s.\n' "$destino" "$origen" >&2
  return 1
}
