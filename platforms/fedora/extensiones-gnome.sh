#!/usr/bin/env bash

# Instala y activa extensiones GNOME mantenidas sin almacenar sus preferencias.

URL_EXTENSIONS_GNOME='https://extensions.gnome.org'

EXTENSIONES_GNOME=(
  appindicator
  custom-hot-corners
  clipboard-indicator
  vitals
  dash-to-dock
)

declare -gA EXTENSION_GNOME_NOMBRE=(
  [appindicator]='AppIndicator'
  [custom-hot-corners]='Custom Hot Corners Extended'
  [clipboard-indicator]='Clipboard Indicator'
  [vitals]='Vitals'
  [dash-to-dock]='Dash to Dock'
)

declare -gA EXTENSION_GNOME_UUID=(
  [appindicator]='appindicatorsupport@rgcjonas.gmail.com'
  [custom-hot-corners]='custom-hot-corners-extended@G-dH.github.com'
  [clipboard-indicator]='clipboard-indicator@tudmotu.com'
  [vitals]='Vitals@CoreCoding.com'
  [dash-to-dock]='dash-to-dock@micxgx.gmail.com'
)

declare -gA EXTENSION_GNOME_ORIGEN=(
  [appindicator]='dnf'
  [custom-hot-corners]='extensions.gnome.org'
  [clipboard-indicator]='extensions.gnome.org'
  [vitals]='extensions.gnome.org'
  [dash-to-dock]='dnf'
)

registrar_extension_gnome() {
  local categoria=$1
  local mensaje=$2
  if declare -F registrar_resultado >/dev/null; then
    registrar_resultado "$categoria" "$mensaje"
  else
    printf '[%s] %s\n' "$categoria" "$mensaje"
  fi
}

obtener_version_gnome_shell() {
  local salida version
  salida=$(gnome-shell --version 2>/dev/null) || return 1
  version=${salida##* }
  [[ $version =~ ^[0-9]+([.][0-9]+)*$ ]] || return 1
  printf '%s\n' "${version%%.*}"
}

obtener_url_extension_gnome() {
  local uuid=$1
  local version_shell=$2
  local respuesta ruta

  respuesta=$(curl --fail --location --silent --show-error \
    "$URL_EXTENSIONS_GNOME/extension-info/?uuid=$uuid&shell_version=$version_shell") || return 1
  ruta=$(printf '%s' "$respuesta" | python3 -c '
import json
import sys

datos = json.load(sys.stdin)
ruta = datos.get("download_url", "")
if not isinstance(ruta, str) or not ruta.startswith("/download-extension/"):
    raise SystemExit(1)
print(ruta)
') || return 1
  printf '%s%s\n' "$URL_EXTENSIONS_GNOME" "$ruta"
}

extension_gnome_instalada() {
  gnome-extensions info "$1" >/dev/null 2>&1
}

extension_gnome_activa() {
  gnome-extensions list --enabled 2>/dev/null | grep -Fxq "$1"
}

instalar_extension_desde_ego() {
  local nombre=$1
  local uuid=$2
  local version_shell=$3
  local url temporal

  url=$(obtener_url_extension_gnome "$uuid" "$version_shell") || {
    registrar_extension_gnome fallidos "$nombre ($uuid): no hay una publicación compatible en extensions.gnome.org"
    return 1
  }
  temporal=$(mktemp "${TMPDIR:-/tmp}/extension-gnome.XXXXXX.zip") || {
    registrar_extension_gnome fallidos "$nombre ($uuid): no se pudo crear el archivo temporal"
    return 1
  }
  if ! curl --fail --location --silent --show-error --output "$temporal" "$url"; then
    rm -f "$temporal"
    registrar_extension_gnome fallidos "$nombre ($uuid): no se pudo descargar la publicación compatible"
    return 1
  fi
  if ! gnome-extensions install --force "$temporal" >/dev/null 2>&1; then
    rm -f "$temporal"
    registrar_extension_gnome fallidos "$nombre ($uuid): no se pudo instalar la publicación descargada"
    return 1
  fi
  rm -f "$temporal"
  if ! extension_gnome_instalada "$uuid"; then
    registrar_extension_gnome fallidos "$nombre ($uuid): GNOME Shell no reconoce la extensión instalada"
    return 1
  fi
  registrar_extension_gnome instalados "$nombre ($uuid): instalada desde extensions.gnome.org"
}

activar_extension_gnome() {
  local nombre=$1
  local uuid=$2

  if extension_gnome_activa "$uuid"; then
    registrar_extension_gnome presentes "$nombre ($uuid): ya estaba activa"
    return 0
  fi
  if ! gnome-extensions enable "$uuid" >/dev/null 2>&1; then
    registrar_extension_gnome fallidos "$nombre ($uuid): no se pudo activar"
    return 1
  fi
  if ! extension_gnome_instalada "$uuid"; then
    registrar_extension_gnome fallidos "$nombre ($uuid): GNOME Shell no reconoce la extensión activada"
    return 1
  fi
  if extension_gnome_activa "$uuid"; then
    registrar_extension_gnome instalados "$nombre ($uuid): activada"
  else
    registrar_extension_gnome pendientes "$nombre ($uuid): cierra e inicia sesión manualmente para aplicar la activación"
  fi
}

procesar_extension_gnome() {
  local id=$1
  local nombre=${EXTENSION_GNOME_NOMBRE[$id]}
  local uuid=${EXTENSION_GNOME_UUID[$id]}
  local origen=${EXTENSION_GNOME_ORIGEN[$id]}
  local version_shell=$2

  if ! extension_gnome_instalada "$uuid"; then
    if [[ $origen != extensions.gnome.org ]]; then
      registrar_extension_gnome fallidos "$nombre ($uuid): no está disponible tras instalar su paquete DNF"
      return 1
    fi
    instalar_extension_desde_ego "$nombre" "$uuid" "$version_shell" || return 1
  fi
  activar_extension_gnome "$nombre" "$uuid"
}

ejecutar_extensiones_gnome() {
  local version_shell id
  local hubo_fallos=false

  if ! command -v gnome-shell >/dev/null 2>&1 || ! command -v gnome-extensions >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1 || ! command -v python3 >/dev/null 2>&1; then
    registrar_extension_gnome fallidos 'Extensiones GNOME: faltan comandos requeridos para gestionarlas'
    return 1
  fi
  version_shell=$(obtener_version_gnome_shell) || {
    registrar_extension_gnome fallidos 'Extensiones GNOME: no se pudo detectar la versión de GNOME Shell'
    return 1
  }
  for id in "${EXTENSIONES_GNOME[@]}"; do
    procesar_extension_gnome "$id" "$version_shell" || hubo_fallos=true
  done
  [[ $hubo_fallos == false ]]
}
