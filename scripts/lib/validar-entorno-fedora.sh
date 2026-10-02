#!/usr/bin/env bash

# Valida Fedora Workstation con GNOME sin realizar cambios en el equipo.

obtener_valor_os_release() {
  local archivo=$1
  local clave=$2
  local linea valor

  linea=$(grep -E "^${clave}=" "$archivo" | head -n 1) || return 1
  valor=${linea#*=}
  valor=${valor#\"}
  valor=${valor%\"}
  printf '%s\n' "$valor"
}

validar_entorno_fedora() {
  local metadatos=$1
  local os_release=${2:-/etc/os-release}
  local escritorio=${3:-${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-}}}
  local id variante version esperada edicion escritorio_esperado

  id=$(obtener_valor_os_release "$os_release" ID) || {
    printf 'No se pudo leer el identificador del sistema operativo.\n' >&2
    return 1
  }
  variante=$(obtener_valor_os_release "$os_release" VARIANT_ID 2>/dev/null || true)
  version=$(obtener_valor_os_release "$os_release" VERSION_ID) || {
    printf 'No se pudo leer la versión de Fedora.\n' >&2
    return 1
  }

  # El repositorio controla este fichero y lo usa como contrato por referencia.
  # shellcheck source=/dev/null
  source "$metadatos"
  esperada=$FEDORA_VERSION
  edicion=$FEDORA_EDITION
  escritorio_esperado=$FEDORA_DESKTOP

  if [[ $id != fedora ]]; then
    printf 'Sistema no compatible: se requiere Fedora Workstation.\n' >&2
    return 1
  fi
  if [[ ${variante,,} != "$edicion" ]]; then
    printf 'Edición no compatible: se requiere Fedora Workstation.\n' >&2
    return 1
  fi
  if [[ $version != "$esperada" ]]; then
    printf 'Versión no compatible: esta referencia requiere Fedora %s y se detectó Fedora %s.\n' "$esperada" "$version" >&2
    return 1
  fi
  if [[ ${escritorio,,} != *"$escritorio_esperado"* ]]; then
    printf 'Sesión no compatible: se requiere GNOME.\n' >&2
    return 1
  fi

  printf 'Entorno compatible: Fedora Workstation %s con GNOME.\n' "$version"
}
