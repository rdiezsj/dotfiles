#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
export HOME="$TEMPORAL/home"
mkdir -p "$HOME/.config" "$TEMPORAL/bin"

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/zsh-terminal.sh"

zsh -n "$RAIZ/home/.zshrc" "$RAIZ/home/.zsh_aliases" "$RAIZ/home/.zprofile"
! rg -n -i 'token|secret|password|bw_session' "$RAIZ/home/.zshrc" "$RAIZ/home/.zsh_aliases" "$RAIZ/home/.profile" "$RAIZ/home/.zprofile" "$RAIZ/home/config/starship.toml"

registro="$TEMPORAL/registro"
registrar_resultado() {
  printf '%s:%s\n' "$1" "$2" >>"$registro"
}

ejecutar_dotbot_zsh() {
  "$RAIZ/dotbot/bin/dotbot" -d "$RAIZ" -c "$RAIZ/install.conf.yaml"
}

configurar_archivos_zsh "$RAIZ"
for relativo in .zshrc .zsh_aliases .profile .zprofile .config/starship.toml; do
  [[ -L $HOME/$relativo ]]
  if [[ $relativo == .config/starship.toml ]]; then
    [[ $(readlink -f "$HOME/$relativo") == "$RAIZ/home/config/starship.toml" ]]
  else
    [[ $(readlink -f "$HOME/$relativo") == "$RAIZ/home/$relativo" ]]
  fi
done

configurar_archivos_zsh "$RAIZ"
[[ $(grep -Fc 'Zsh: archivos versionados enlazados mediante Dotbot' "$registro") == 2 ]]

rm "$HOME/.zshrc"
printf '%s\n' 'configuración anterior' >"$HOME/.zshrc"
configurar_archivos_zsh "$RAIZ"
respaldo=$(find "$HOME/.dotfiles-backups" -type f -name .zshrc -print -quit)
[[ -n $respaldo ]]
grep -Fqx 'configuración anterior' "$respaldo"
[[ -L $HOME/.zshrc ]]

PATH="$TEMPORAL/bin:$PATH"
printf '%s\n' '#!/usr/bin/env bash' 'exit 0' >"$TEMPORAL/bin/zsh"
chmod +x "$TEMPORAL/bin/zsh"
id() { printf '%s\n' prueba; }
getent() { printf 'prueba:x:1000:1000::/home/prueba:/bin/bash\n'; }
chsh() { printf '%s\n' "$*" >>"$TEMPORAL/chsh"; }
confirmar_cambio_shell_zsh() { return 1; }
ofrecer_shell_zsh_predeterminada
[[ ! -e $TEMPORAL/chsh ]]

confirmar_cambio_shell_zsh() { return 0; }
ofrecer_shell_zsh_predeterminada
grep -Fqx -- "-s $TEMPORAL/bin/zsh prueba" "$TEMPORAL/chsh"

getent() { printf 'prueba:x:1000:1000::/home/prueba:%s\n' "$TEMPORAL/bin/zsh"; }
ofrecer_shell_zsh_predeterminada
grep -Fqx 'presentes:Zsh ya es la shell predeterminada' "$registro"
