#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

for archivo in \
  home/.nanorc \
  home/.vimrc \
  home/.gitconfig \
  home/.gitignore \
  home/.config/terminator/config \
  home/.local/bin/terminator \
  home/.local/share/applications/terminator.desktop \
  home/.config/ptyxis/config.dconf \
  home/.config/zellij/config.kdl \
  home/.config/flameshot/flameshot.ini \
  home/.config/Heynote/config.json \
  home/.config/Heynote/Preferences \
  home/.config/input-remapper-2/config.json \
  'home/.config/input-remapper-2/presets/Logitech MX Master 3/cambio de escritorio.json' \
  home/.config/msmtp/config; do
  [[ -f $RAIZ/$archivo ]]
done
[[ -d $RAIZ/home/.config/terminator/plugins ]]
[[ -f $RAIZ/home/.config/terminator/plugins/.gitkeep ]]
[[ -x $RAIZ/home/.local/bin/terminator ]]
grep -Fqx 'export GTK_THEME=Adwaita:dark' "$RAIZ/home/.local/bin/terminator"
grep -Fqx 'exec /usr/bin/terminator "$@"' "$RAIZ/home/.local/bin/terminator"
grep -Fqx 'Exec=/usr/bin/env GTK_THEME=Adwaita:dark /usr/bin/terminator' "$RAIZ/home/.local/share/applications/terminator.desktop"
grep -Fqx 'Actions=NewWindow;' "$RAIZ/home/.local/share/applications/terminator.desktop"
grep -Fqx '[Desktop Action NewWindow]' "$RAIZ/home/.local/share/applications/terminator.desktop"
grep -Fqx 'Exec=/usr/bin/env GTK_THEME=Adwaita:dark /usr/bin/terminator --new-tab' "$RAIZ/home/.local/share/applications/terminator.desktop"
grep -Fqx "default-profile-uuid='b3a9ca574b7b4bbd9c73a56c3e254ef4'" "$RAIZ/home/.config/ptyxis/config.dconf"
grep -Fqx "palette='nord'" "$RAIZ/home/.config/ptyxis/config.dconf"
grep -Fqx 'limit-scrollback=false' "$RAIZ/home/.config/ptyxis/config.dconf"
! rg -n '^\[.*\]$' "$RAIZ/home/.config/ptyxis/config.dconf" | grep -Fv -e '[/]' -e '[Profiles/b3a9ca574b7b4bbd9c73a56c3e254ef4]'
! rg -n -i '^(keybinds|plugins|layout|default_layout|default_mode)' "$RAIZ/home/.config/zellij/config.kdl"

git config --file "$RAIZ/home/.gitconfig" --get core.excludesfile | grep -Fqx '~/.gitignore'
jq -e . "$RAIZ/home/.config/Heynote/config.json" "$RAIZ/home/.config/Heynote/Preferences" "$RAIZ/home/.config/input-remapper-2/config.json" >/dev/null
jq -e '.autoload == {"Logitech MX Master 3":"cambio de escritorio"}' "$RAIZ/home/.config/input-remapper-2/config.json" >/dev/null

[[ $(find "$RAIZ/home/.config/Heynote" -maxdepth 1 -type f | wc -l) -eq 2 ]]
grep -Fqx 'saveAsFileExtension=png' "$RAIZ/home/.config/flameshot/flameshot.ini"
grep -Fqx 'startupLaunch=true' "$RAIZ/home/.config/flameshot/flameshot.ini"
grep -Fqx 'host smtp.ionos.es' "$RAIZ/home/.config/msmtp/config"
grep -Fqx 'from fedora_desktop@rdiez.es' "$RAIZ/home/.config/msmtp/config"
grep -Fqx 'eval ~/.dotfiles/bin/msmtp-obtener-usuario' "$RAIZ/home/.config/msmtp/config"
grep -Fqx 'passwordeval ~/.dotfiles/bin/msmtp-obtener-contrasena' "$RAIZ/home/.config/msmtp/config"
grep -Fqx 'logfile ~/.local/state/msmtp/msmtp.log' "$RAIZ/home/.config/msmtp/config"
! rg -n -i '^(user|password)[[:space:]]|BW_SESSION|token[[:space:]]*=' "$RAIZ/home/.config/msmtp/config"
! rg -n -i '(password\s*=\s*[^<]|token\s*=|secret\s*=)' "$RAIZ/home"
[[ ! -d $RAIZ/templates ]]

for destino in \
  '~/.nanorc: home/.nanorc' \
  '~/.vimrc: home/.vimrc' \
  '~/.gitconfig: home/.gitconfig' \
  '~/.gitignore: home/.gitignore' \
  '~/.config/terminator: home/.config/terminator' \
  '~/.local/bin/terminator: home/.local/bin/terminator' \
  '~/.local/share/applications/terminator.desktop: home/.local/share/applications/terminator.desktop' \
  '~/.config/ptyxis/config.dconf: home/.config/ptyxis/config.dconf' \
  '~/.config/zellij/config.kdl: home/.config/zellij/config.kdl' \
  '~/.config/flameshot/flameshot.ini: home/.config/flameshot/flameshot.ini' \
  '~/.config/Heynote/config.json: home/.config/Heynote/config.json' \
  '~/.config/Heynote/Preferences: home/.config/Heynote/Preferences' \
  '~/.config/input-remapper-2: home/.config/input-remapper-2' \
  '~/.config/msmtp/config: home/.config/msmtp/config'; do
  grep -Fqx "    $destino" "$RAIZ/install.conf.yaml"
done
