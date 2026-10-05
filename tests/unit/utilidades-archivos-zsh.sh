#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

mkdir -p "$TEMPORAL/entrada"
printf '%s\n' 'contenido de prueba' >"$TEMPORAL/entrada/archivo.txt"
tar -czf "$TEMPORAL/archivo.tar.gz" -C "$TEMPORAL" entrada
tar -cJf "$TEMPORAL/archivo.tar.xz" -C "$TEMPORAL" entrada
(cd "$TEMPORAL" && zip -rq archivo.zip entrada)
(cd "$TEMPORAL" && 7z a -t7z -bd archivo.7z entrada >/dev/null)

zsh -fc '
  source "$1"
  gum() { return 0; }
  for archivo in "$2"/archivo.tar.gz "$2"/archivo.tar.xz "$2"/archivo.zip "$2"/archivo.7z; do
    extract "$archivo"
  done
  [[ -f "$2/archivo/entrada/archivo.txt" ]]
  extract "$2/no-existe" >/dev/null 2>&1 && exit 1
  extract "$2/entrada/archivo.txt" >/dev/null 2>&1 && exit 1
' zsh "$RAIZ/home/.zsh_functions" "$TEMPORAL"

zsh -fc '
  source "$1"
  output=$2/salida.tar.gz
  bloques="Sin dividir"
  gum() {
    case $1 in
      choose)
        case "$*" in
          *Formato*) print -r -- "$formato" ;;
          *Nivel*) print -r -- Normal ;;
          *Dividir*) print -r -- "$bloques" ;;
        esac
        ;;
      input) print -r -- "$output" ;;
      confirm) return 1 ;;
    esac
  }
  compress "$2/entrada"
  tar -tzf "$output" | grep -Fqx entrada/archivo.txt
  [[ -f "$2/entrada/archivo.txt" ]]

  formato=zip
  output=$2/salida.zip
  compress "$2/entrada"
  unzip -tqq "$output"

  formato=7z
  output=$2/salida.7z
  compress "$2/entrada"
  7z t -bd "$output" >/dev/null

  formato=tar.xz
  output=$2/dividido.tar.xz
  bloques=100M
  compress "$2/entrada"
  [[ -f "${output}.part-000" ]]
  cat "${output}".part-* >"$output"
  tar -tJf "$output" | grep -Fqx entrada/archivo.txt

  print -r -- conservar >"$2/existente.tar.gz"
  output=$2/existente.tar.gz
  bloques="Sin dividir"
  compress "$2/entrada"
  [[ $(<$2/existente.tar.gz) == conservar ]]
' zsh "$RAIZ/home/.zsh_functions" "$TEMPORAL"

zsh -fc '
  source "$1"
  compress "$2/entrada" >/dev/null 2>&1 && exit 1
' zsh "$RAIZ/home/.zsh_functions" "$TEMPORAL"
