#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
mkdir -p "$TEMPORAL/bin" "$TEMPORAL/scripts"
cp "$RAIZ/bin/dotfiles" "$TEMPORAL/bin/dotfiles"
ln -s "$(command -v dirname)" "$TEMPORAL/bin/dirname"
export REGISTRO="$TEMPORAL/operaciones" DOTFILES_HOME="$TEMPORAL/despliegue"
cat > "$TEMPORAL/scripts/actualizar.sh" <<'ACTUALIZAR'
#!/bin/bash
[[ $# == 0 ]] || exit 99
printf '%s\n' "$DOTFILES_HOME" > "$REGISTRO"
exit 37
ACTUALIZAR
chmod +x "$TEMPORAL/scripts/actualizar.sh"

# El acceso al mantenimiento no debe depender de Python.
set +e
PATH="$TEMPORAL/bin" /bin/bash "$TEMPORAL/bin/dotfiles" update
codigo=$?
set -e
[[ $codigo == 37 ]]
grep -Fqx "$DOTFILES_HOME" "$REGISTRO"
rm "$REGISTRO"

/bin/bash "$TEMPORAL/bin/dotfiles" update --help | grep -Fq 'Uso:'
[[ ! -e $REGISTRO ]]
set +e
/bin/bash "$TEMPORAL/bin/dotfiles" update --reparar > "$TEMPORAL/salida" 2>&1
codigo=$?
set -e
[[ $codigo == 2 && ! -e $REGISTRO ]]
grep -Fq 'Uso:' "$TEMPORAL/salida"
grep -Fqx "alias update='\$HOME/.dotfiles/scripts/actualizar.sh'" "$RAIZ/home/.zsh_aliases"
printf '%s\n' 'PASS dotfiles update: delegación, código de salida, ayuda y alias existente'
