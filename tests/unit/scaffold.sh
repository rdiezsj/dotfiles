#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/scaffold.sh"

HOME="$TEMPORAL/home"
export HOME
export XDG_CONFIG_HOME="$TEMPORAL/config"
export DOTFILES_TEMPLATES_DIR="$HOME/Plantillas"
mkdir -p "$HOME" "$XDG_CONFIG_HOME"

mkdir -p "$HOME/Plantillas"
crear_scaffold_personal "$RAIZ/config/scaffold/carpetas.sh"
instalar_plantillas_nautilus "$RAIZ/config/nautilus-templates"

marca_texto=$(stat -c %Y "$HOME/Plantillas/Texto.txt")
crear_scaffold_personal "$RAIZ/config/scaffold/carpetas.sh"
instalar_plantillas_nautilus "$RAIZ/config/nautilus-templates"
[[ $marca_texto == "$(stat -c %Y "$HOME/Plantillas/Texto.txt")" ]]

test -d "$HOME/Code"
test -d "$HOME/PKM"
test -d "$HOME/Apps"
test -d "$HOME/Descargas/Trash"
test -f "$HOME/Plantillas/Texto.txt"
test -f "$HOME/Plantillas/Documento.md"
test -f "$HOME/Plantillas/Script.sh"
