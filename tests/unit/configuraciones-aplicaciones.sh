#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

for archivo in \
  home/.nanorc \
  home/.vimrc \
  home/.gitconfig \
  home/.gitignore \
  home/config/terminator/config \
  home/config/flameshot/flameshot.ini \
  home/config/Heynote/config.json \
  home/config/Heynote/Preferences \
  home/config/input-remapper-2/config.json \
  home/config/msmtp/config; do
  [[ -f $RAIZ/$archivo ]]
done
[[ -d $RAIZ/home/config/terminator/plugins ]]
[[ -f $RAIZ/home/config/terminator/plugins/.gitkeep ]]

git config --file "$RAIZ/home/.gitconfig" --get core.excludesfile | grep -Fqx '~/.gitignore'
jq -e . "$RAIZ/home/config/Heynote/config.json" "$RAIZ/home/config/Heynote/Preferences" "$RAIZ/home/config/input-remapper-2/config.json" >/dev/null
jq -e '.autoload == {"Logitech MX Master 3":"cambio de escritorio"}' "$RAIZ/home/config/input-remapper-2/config.json" >/dev/null

[[ $(find "$RAIZ/home/config/Heynote" -maxdepth 1 -type f | wc -l) -eq 2 ]]
grep -Fqx 'host smtp.ionos.es' "$RAIZ/home/config/msmtp/config"
grep -Fqx 'from fedora_desktop@rdiez.es' "$RAIZ/home/config/msmtp/config"
grep -Fqx 'eval ~/.dotfiles/bin/msmtp-obtener-usuario' "$RAIZ/home/config/msmtp/config"
grep -Fqx 'passwordeval ~/.dotfiles/bin/msmtp-obtener-contrasena' "$RAIZ/home/config/msmtp/config"
grep -Fqx 'logfile ~/.local/state/msmtp/msmtp.log' "$RAIZ/home/config/msmtp/config"
! rg -n -i '^(user|password)[[:space:]]|BW_SESSION|token[[:space:]]*=' "$RAIZ/home/config/msmtp/config"
! rg -n -i '(password\s*=\s*[^<]|token\s*=|secret\s*=)' "$RAIZ/home"
! rg -F 'gearlever' "$RAIZ/install.conf.yaml"
[[ ! -d $RAIZ/templates ]]

for destino in \
  '~/.nanorc: home/.nanorc' \
  '~/.vimrc: home/.vimrc' \
  '~/.gitconfig: home/.gitconfig' \
  '~/.gitignore: home/.gitignore' \
  '~/.config/terminator: home/config/terminator' \
  '~/.config/flameshot/flameshot.ini: home/config/flameshot/flameshot.ini' \
  '~/.config/Heynote/config.json: home/config/Heynote/config.json' \
  '~/.config/Heynote/Preferences: home/config/Heynote/Preferences' \
  '~/.config/input-remapper-2/config.json: home/config/input-remapper-2/config.json' \
  '~/.config/msmtp/config: home/config/msmtp/config'; do
  grep -Fqx "    $destino" "$RAIZ/install.conf.yaml"
done
