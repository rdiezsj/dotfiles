#!/usr/bin/env bash
set -euo pipefail
RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
export HOME="$TEMPORAL/home"
export GIT_CONFIG_NOSYSTEM=1
unset GIT_CONFIG_GLOBAL
mkdir -p "$HOME"
source "$RAIZ/platforms/fedora/scaffold.sh"
configurar_identidad_git <<< $'Persona de prueba\nprueba@example.invalid'
[[ $(git config --file "$HOME/.gitconfig.local" user.name) == 'Persona de prueba' ]]
[[ $(git config --file "$HOME/.gitconfig.local" user.email) == prueba@example.invalid ]]
[[ $(stat -c %a "$HOME/.gitconfig.local") == 600 ]]
cp "$RAIZ/home/.gitconfig" "$HOME/.gitconfig"
[[ $(git config --global --includes user.name) == 'Persona de prueba' ]]
[[ $(git config --global --includes user.email) == prueba@example.invalid ]]
configurar_identidad_git </dev/null
mkdir "$TEMPORAL/repo"
git -C "$TEMPORAL/repo" init -q
git -C "$TEMPORAL/repo" config core.excludesfile "$RAIZ/home/.gitignore"
touch "$TEMPORAL/repo/.gitconfig.local"
git -C "$TEMPORAL/repo" check-ignore -q .gitconfig.local
export HOME="$TEMPORAL/omitida"
mkdir -p "$HOME"
configurar_identidad_git <<< ''
[[ ! -e "$HOME/.gitconfig.local" ]]
git config --global user.name 'Identidad existente'
git config --global user.email existente@example.invalid
configurar_identidad_git </dev/null
[[ $(git config --file "$HOME/.gitconfig.local" user.name) == 'Identidad existente' ]]
[[ $(git config --file "$HOME/.gitconfig.local" user.email) == existente@example.invalid ]]
