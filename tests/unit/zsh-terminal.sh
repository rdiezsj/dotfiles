#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
export HOME="$TEMPORAL/home"
mkdir -p "$HOME/.config" "$TEMPORAL/bin"

cat >"$TEMPORAL/bin/sheldon" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

perfil=
comando=
while (( $# > 0 )); do
  case $1 in
    --profile)
      perfil=$2
      shift
      ;;
    lock|source) comando=$1 ;;
  esac
  shift
done
if [[ $comando == source ]]; then
  printf '%s\n' 'extract() { print -r -- plugin; }'
  exit 0
fi
mkdir -p "${SHELDON_DATA_DIR:?}"
touch "${SHELDON_DATA_DIR}/plugins.${perfil}.lock"
EOF
chmod +x "$TEMPORAL/bin/sheldon"
export PATH="$TEMPORAL/bin:$PATH"

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/zsh-terminal.sh"

zsh -n "$RAIZ/home/.zshrc" "$RAIZ/home/.zsh_aliases" "$RAIZ/home/.zsh_functions" "$RAIZ/home/.zprofile"
! rg -n -i 'token|secret|password|bw_session' "$RAIZ/home/.zshrc" "$RAIZ/home/.zsh_aliases" "$RAIZ/home/.zsh_functions" "$RAIZ/home/.profile" "$RAIZ/home/.zprofile" "$RAIZ/home/config/starship.toml"
[[ $(grep -Ec '^rev = "[[:xdigit:]]{40}"$' "$RAIZ/home/config/sheldon/plugins.toml") -eq 6 ]]
grep -Fqx 'profiles = ["base"]' "$RAIZ/home/config/sheldon/plugins.toml"
grep -Fqx 'profiles = ["resaltado"]' "$RAIZ/home/config/sheldon/plugins.toml"
! rg -n -i 'token|secret|password|bw_session' "$RAIZ/home/config/sheldon/plugins.toml"
! rg -F 'sheldon lock --update' "$RAIZ/home/.zshrc"
salida_no_interactiva=$(zsh -fc 'source "$1"' zsh "$RAIZ/home/.zshrc")
[[ -z $salida_no_interactiva ]]

registro="$TEMPORAL/registro"
registrar_resultado() {
  printf '%s:%s\n' "$1" "$2" >>"$registro"
}

ejecutar_dotbot_zsh() {
  "$RAIZ/dotbot/bin/dotbot" -d "$RAIZ" -c "$RAIZ/install.conf.yaml"
}

configurar_archivos_zsh "$RAIZ"
for relativo in .zshrc .zsh_aliases .zsh_functions .profile .zprofile .config/starship.toml .config/sheldon/plugins.toml; do
  [[ -L $HOME/$relativo ]]
  if [[ $relativo == .config/* ]]; then
    [[ $(readlink -f "$HOME/$relativo") == "$RAIZ/home/config/${relativo#.config/}" ]]
  else
    [[ $(readlink -f "$HOME/$relativo") == "$RAIZ/home/$relativo" ]]
  fi
done
[[ -f $HOME/.local/share/sheldon/plugins.base.lock ]]
[[ -f $HOME/.local/share/sheldon/plugins.resaltado.lock ]]
[[ ! -L $HOME/.local/share/sheldon/plugins.base.lock ]]
[[ ! -L $HOME/.local/share/sheldon/plugins.resaltado.lock ]]

configurar_archivos_zsh "$RAIZ"
[[ $(grep -Fc 'Zsh: archivos versionados enlazados mediante Dotbot' "$registro") == 2 ]]
grep -Fqx 'instalados:Sheldon: plugins Zsh materializados en el estado local' "$registro"
grep -Fqx 'presentes:Sheldon: estado local de plugins ya materializado' "$registro"
zsh -dfic 'source "$1"; typeset -f extract | grep -Fq "Extract: no existe un archivo válido"' zsh "$HOME/.zshrc"

mkdir -p "$HOME/.local/bin" "$HOME/.dotfiles/bin" "$HOME/.krew/bin"
zsh -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- "extract() { :; }"; }
  fzf() { [[ $1 == --zsh ]] && print -r -- ":"; }
  starship() { [[ $1 == init ]] && print -r -- ":"; }
  kubectl() { [[ $1 == completion && $2 == zsh ]] && print -r -- "typeset -g KUBECTL_COMPLETION_PRUEBA=si"; }
  source "$1"
  [[ $DOTFILES == "$HOME/.dotfiles" ]]
  [[ $(print -l -- $path | grep -Fxc "$HOME/.local/bin") == 1 ]]
  [[ $(print -l -- $path | grep -Fxc "$HOME/.dotfiles/bin") == 1 ]]
  [[ $(print -l -- $path | grep -Fxc "$HOME/.krew/bin") == 1 ]]
  [[ $PATH != *"/opt/homebrew/bin"* ]]
  [[ " $FZF_DEFAULT_OPTS " == *" --height 40% "* ]]
  [[ " $FZF_DEFAULT_OPTS " == *" --layout=reverse "* ]]
  [[ " $FZF_DEFAULT_OPTS " == *" --border "* ]]
  [[ $(bindkey -M main "^A") == *beginning-of-line* ]]
  [[ $KUBECTL_COMPLETION_PRUEBA == si ]]
  source "$1"
  [[ $(print -l -- $path | grep -Fxc "$HOME/.local/bin") == 1 ]]
' zsh "$HOME/.zshrc"

rm "$HOME/.zshrc"
printf '%s\n' 'configuración anterior' >"$HOME/.zshrc"
configurar_archivos_zsh "$RAIZ"
respaldo=$(find "$HOME/.dotfiles-backups" -type f -name .zshrc -print -quit)
[[ -n $respaldo ]]
grep -Fqx 'configuración anterior' "$respaldo"
[[ -L $HOME/.zshrc ]]

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
