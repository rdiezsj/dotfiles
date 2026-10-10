#!/usr/bin/env bash
set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
export HOME="$TEMPORAL/home" ZDOTDIR="$TEMPORAL/home"
export XDG_CONFIG_HOME="$HOME/.config" XDG_DATA_HOME="$HOME/.local/share" XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES="$RAIZ" DOTFILES_SKIP_BREW_SHELLENV=true
unset BW_SESSION
export REGISTRO_BW="$TEMPORAL/registro"
mkdir -p "$HOME" "$TEMPORAL/bin"
cat >"$TEMPORAL/bin/secret-tool" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' llavero >>"$REGISTRO_BW"
[[ $* == "lookup service dotfiles-vaultwarden account $USER" ]] || exit 1
[[ ${SESION_PRUEBA:-} != ausente ]] || exit 1
printf '%s\n' "$SESION_PRUEBA"
EOF
cat >"$TEMPORAL/bin/bw" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' bw >>"$REGISTRO_BW"
[[ $* == 'list folders --raw' && ${BW_SESSION:-} == sesion-ficticia ]]
EOF
for comando in brew sheldon fzf kubectl starship; do
  printf '#!/usr/bin/env bash\nexit 0\n' >"$TEMPORAL/bin/$comando"
done
chmod +x "$TEMPORAL/bin/"*
export PATH="$TEMPORAL/bin:/usr/bin:/bin"
export SESION_PRUEBA=sesion-ficticia
zsh -dfi -c 'source "$DOTFILES/home/.zshrc"'
[[ ! -e $REGISTRO_BW ]] || {
  printf '%s\n' 'El arranque de Zsh accedió al llavero o ejecutó Bitwarden.' >&2
  exit 1
}
for terminal in 1 2; do
  zsh -dfi -c 'source "$DOTFILES/home/.zshrc"; bw list folders --raw' || {
    printf 'La terminal %s no recuperó la sesión del llavero.\n' "$terminal" >&2
    exit 1
  }
done
[[ $(grep -c '^bw$' "$REGISTRO_BW") == 2 ]]
BW_SESSION=sesion-ficticia zsh -dfi -c 'source "$DOTFILES/home/.zshrc"; bw list folders --raw'
[[ $(grep -c '^llavero$' "$REGISTRO_BW") == 2 ]]
for SESION_PRUEBA in ausente invalida ''; do
  export SESION_PRUEBA
  zsh -dfi -c 'source "$DOTFILES/home/.zshrc"; [[ -z ${BW_SESSION:-} ]]' || exit 1
done
