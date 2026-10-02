#!/usr/bin/env bash

# Clona una referencia en un directorio temporal y valida su contrato antes
# de permitir que el checkout de destino sea creado o actualizado.

clonar_referencia_validada() {
  local remoto=$1
  local referencia=$2
  local destino=$3
  local os_release=${4:-/etc/os-release}
  local escritorio=${5:-${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-}}}
  local temporal

  temporal=$(mktemp -d)
  if ! git clone --quiet --depth 1 --branch "$referencia" "$remoto" "$temporal"; then
    rm -rf "$temporal"
    printf 'No se pudo descargar la referencia %s.\n' "$referencia" >&2
    return 1
  fi

  # shellcheck source=/dev/null
  source "$temporal/scripts/lib/validar-entorno-fedora.sh"
  if ! validar_entorno_fedora "$temporal/platforms/fedora/compatibility.env" "$os_release" "$escritorio"; then
    rm -rf "$temporal"
    return 1
  fi

  if [[ -e $destino ]]; then
    rm -rf "$temporal"
    printf 'El destino %s ya existe; no se ha modificado.\n' "$destino" >&2
    return 1
  fi

  mv "$temporal" "$destino"
}
