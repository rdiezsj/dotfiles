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
[[ $salida == *'DOTFILES FEDORA -- PLAN COMPLETO'* ]]
[[ $salida == *'Simulación completada: no se ha modificado el equipo.'* ]]
[[ $salida == *'| RESUMEN FINAL'* ]]
[[ $salida == *'Omitidos:'* ]]
[[ $salida != *'Abrir ahora una nueva sesión Zsh'* ]]
[[ $salida == *'Aplicar configuraciones versionadas'* ]]
[[ $salida == *'Configurar la cuenta SMTP IONOS bajo demanda.'* ]]
[[ $salida == *'Instalar y activar las extensiones GNOME declaradas.'* ]]
[[ $salida != *'plantilla de Gear Lever'* ]]

linea_catalogo=$(grep -nF "ejecutar_fase 'Catálogo DNF, Homebrew, Flatpak y AppImage'" "$RAIZ/bootstrap" | cut -d: -f1)
linea_extensiones=$(grep -nF "ejecutar_fase 'Extensiones GNOME'" "$RAIZ/bootstrap" | cut -d: -f1)
[[ $linea_catalogo -lt $linea_extensiones ]]

salida_remota=$(printf 'n\n' | DOTFILES_OS_RELEASE="$TEMPORAL/os-release" DOTFILES_DESKTOP=GNOME \
  bash -c "$(<"$RAIZ/bootstrap")" 2>&1)
[[ $salida_remota == *'DOTFILES FEDORA -- PLAN INICIAL'* ]]
[[ $salida_remota == *'Instalación cancelada antes de modificar el equipo.'* ]]

git clone --quiet "$RAIZ" "$TEMPORAL/remoto"
git clone --quiet "$RAIZ/dotbot" "$TEMPORAL/dotbot-origen"
git clone --bare --quiet "$RAIZ/dotbot/lib/pyyaml" "$TEMPORAL/pyyaml"
git -C "$TEMPORAL/dotbot-origen" config -f .gitmodules submodule.lib/pyyaml.url "$TEMPORAL/pyyaml"
git -C "$TEMPORAL/dotbot-origen" add .gitmodules
git -C "$TEMPORAL/dotbot-origen" -c user.name='Pruebas Dotfiles' -c user.email='pruebas@example.invalid' \
  commit --quiet -m 'Aísla PyYAML para la prueba remota'
git clone --bare --quiet "$TEMPORAL/dotbot-origen" "$TEMPORAL/dotbot"
dotbot_referencia=$(git -C "$TEMPORAL/dotbot-origen" rev-parse HEAD)
git -C "$TEMPORAL/remoto" update-index --add --cacheinfo 160000,"$dotbot_referencia",dotbot
git -C "$TEMPORAL/remoto" config -f .gitmodules submodule.dotbot.url "$TEMPORAL/dotbot"
cp "$RAIZ/bootstrap" "$TEMPORAL/remoto/bootstrap"
cp "$RAIZ/platforms/fedora/catalogo-software.sh" "$TEMPORAL/remoto/platforms/fedora/catalogo-software.sh"
cp "$RAIZ/platforms/fedora/extensiones-gnome.sh" "$TEMPORAL/remoto/platforms/fedora/extensiones-gnome.sh"
cp "$RAIZ/platforms/fedora/multimedia-nvidia.sh" "$TEMPORAL/remoto/platforms/fedora/multimedia-nvidia.sh"
cp "$RAIZ/scripts/lib/zsh-terminal.sh" "$TEMPORAL/remoto/scripts/lib/zsh-terminal.sh"
git -C "$TEMPORAL/remoto" add .gitmodules bootstrap platforms/fedora/catalogo-software.sh platforms/fedora/extensiones-gnome.sh platforms/fedora/multimedia-nvidia.sh scripts/lib/zsh-terminal.sh
if ! git -C "$TEMPORAL/remoto" diff --cached --quiet; then
  git -C "$TEMPORAL/remoto" -c user.name='Pruebas Dotfiles' -c user.email='pruebas@example.invalid' \
    commit --quiet -m 'Actualiza bootstrap para la prueba remota'
fi

salida_remota=$(printf 's\nn\n' | DOTFILES_DISABLE_GUM=true \
  DOTFILES_REMOTE="file://$TEMPORAL/remoto" \
  DOTFILES_HOME="$TEMPORAL/dotfiles" \
  DOTFILES_OS_RELEASE="$TEMPORAL/os-release" \
  DOTFILES_DESKTOP=GNOME \
  bash -c "$(<"$RAIZ/bootstrap")" 2>&1)
[[ -d $TEMPORAL/dotfiles ]]
[[ $salida_remota == *'DOTFILES FEDORA -- PLAN COMPLETO'* ]]
[[ $salida_remota == *'Bootstrap cancelado antes de modificar el equipo.'* ]]
[[ $(grep -Fc 'Entorno compatible: Fedora Workstation 44 con GNOME.' <<<"$salida_remota") == 1 ]]
[[ $salida == *'Migración de Zsh y cambio de shell pendientes de una ejecución real'* ]]
