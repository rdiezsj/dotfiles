#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

cat >"$TEMPORAL/os-release" <<'EOF'
ID=fedora
VERSION_ID="44"
VARIANT_ID=workstation
EOF

salida=$(DOTFILES_DISABLE_GUM=true DOTFILES_OS_RELEASE="$TEMPORAL/os-release" DOTFILES_DESKTOP=GNOME "$RAIZ/bootstrap" --dry-run)
[[ $salida == *'Plan completo:'* ]]
[[ $salida == *'Simulación completada: no se ha modificado el equipo.'* ]]
[[ $salida == *'Resumen final:'* ]]
[[ $salida == *'Omitidos:'* ]]

salida_remota=$(printf 'n\n' | bash -c "$(<"$RAIZ/bootstrap")" 2>&1)
[[ $salida_remota == *'Plan inicial:'* ]]
[[ $salida_remota == *'Instalación cancelada antes de modificar el equipo.'* ]]

git clone --quiet "$RAIZ" "$TEMPORAL/remoto"
cp "$RAIZ/bootstrap" "$TEMPORAL/remoto/bootstrap"
git -C "$TEMPORAL/remoto" add bootstrap
git -C "$TEMPORAL/remoto" -c user.name='Pruebas Dotfiles' -c user.email='pruebas@example.invalid' \
  commit --quiet -m 'Actualiza bootstrap para la prueba remota'

salida_remota=$(printf 's\nn\n' | DOTFILES_DISABLE_GUM=true \
  DOTFILES_REMOTE="file://$TEMPORAL/remoto" \
  DOTFILES_HOME="$TEMPORAL/dotfiles" \
  DOTFILES_OS_RELEASE="$TEMPORAL/os-release" \
  DOTFILES_DESKTOP=GNOME \
  bash -c "$(<"$RAIZ/bootstrap")" 2>&1)
[[ -d $TEMPORAL/dotfiles ]]
[[ $salida_remota == *'Plan completo:'* ]]
[[ $salida_remota == *'Bootstrap cancelado antes de modificar el equipo.'* ]]
