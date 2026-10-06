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

confirmar_aplicacion_dotfile() { return 0; }

configurar_archivos_zsh "$RAIZ"
for relativo in .nanorc .vimrc .gitconfig .gitignore .zshrc .zsh_aliases .zsh_functions .profile .zprofile .config/starship.toml .config/sheldon/plugins.toml .config/terminator/config .config/flameshot/flameshot.ini .config/Heynote/config.json .config/Heynote/Preferences .config/input-remapper-2/config.json .config/msmtp/config; do
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

mkdir -p "$TEMPORAL/configuracion-sheldon-ausente"
if XDG_CONFIG_HOME="$TEMPORAL/configuracion-sheldon-ausente" XDG_DATA_HOME="$TEMPORAL/datos-sheldon-ausentes" configurar_plugins_sheldon; then
  printf '%s\n' 'La configuración Sheldon ausente no detuvo la materialización.' >&2
  exit 1
fi
grep -Fqx 'fallidos:Sheldon: falta ~/.config/sheldon/plugins.toml; resuelve el conflicto de Dotbot y vuelve a ejecutar ./bootstrap' "$registro"

sheldon() { return 1; }
if configurar_plugins_sheldon; then
  printf '%s\n' 'Un fallo de Sheldon no detuvo la materialización.' >&2
  exit 1
fi
grep -Fqx 'fallidos:Sheldon: no se pudo materializar el perfil base' "$registro"
unset -f sheldon

configurar_archivos_zsh "$RAIZ"
[[ $(grep -Fc 'Configuración: archivos versionados enlazados mediante Dotbot' "$registro") == 2 ]]
grep -Fqx 'instalados:Sheldon: plugins Zsh materializados en el estado local' "$registro"
grep -Fqx 'presentes:Sheldon: estado local de plugins ya materializado' "$registro"
zsh -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- ":"; }
  source "$1"
  typeset -f extract | grep -Fq "Extract: no existe un archivo válido"
' zsh "$HOME/.zshrc"

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
respaldo=$(find "$HOME/.dotfiles-backups" -type f -path '*/dotbot-*/*' -name .zshrc -print -quit)
[[ -n $respaldo ]]
grep -Fqx 'configuración anterior' "$respaldo"
[[ -L $HOME/.zshrc ]]

rm "$HOME/.gitconfig"
printf '%s\n' '[user]' '  name = Configuración local' >"$HOME/.gitconfig"
confirmar_aplicacion_dotfile() { return 1; }
if salida_conflicto=$(configurar_archivos_zsh "$RAIZ" 2>&1); then
  printf '%s\n' 'El conflicto no confirmado no detuvo Dotbot.' >&2
  exit 1
fi
[[ $salida_conflicto == *"Destino que se va a sobrescribir: $HOME/.gitconfig"* ]]
[[ $salida_conflicto == *"Dotfile versionado: $RAIZ/home/.gitconfig"* ]]
grep -Fqx '[user]' "$HOME/.gitconfig"
[[ ! -L $HOME/.gitconfig ]]

confirmar_aplicacion_dotfile() { return 0; }
configurar_archivos_zsh "$RAIZ"
respaldo_git=$(find "$HOME/.dotfiles-backups" -type f -path '*/dotbot-*/*' -name .gitconfig -print -quit)
[[ -n $respaldo_git ]]
grep -Fqx '[user]' "$respaldo_git"
[[ -L $HOME/.gitconfig ]]

rm "$HOME/.zshrc" "$HOME/.gitconfig"
printf '%s\n' 'zsh local' >"$HOME/.zshrc"
printf '%s\n' '[user]' '  name = Git local' >"$HOME/.gitconfig"
confirmaciones=0
confirmar_aplicacion_dotfile() {
  confirmaciones=$((confirmaciones + 1))
  [[ $confirmaciones -eq 1 ]]
}
if configurar_archivos_zsh "$RAIZ" >/dev/null 2>&1; then
  printf '%s\n' 'El segundo conflicto rechazado no detuvo Dotbot.' >&2
  exit 1
fi
grep -Fqx 'zsh local' "$HOME/.zshrc"
grep -Fqx '  name = Git local' "$HOME/.gitconfig"
[[ ! -L $HOME/.zshrc && ! -L $HOME/.gitconfig ]]

mkdir -p "$TEMPORAL/sheldon-config"
salida_sheldon=$(zsh -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- ":"; }
  SHELDON_CONFIG_DIR="$2"
  SHELDON_DATA_DIR="$3"
  source "$1"
' zsh "$RAIZ/home/.zshrc" "$TEMPORAL/sheldon-config" "$TEMPORAL/sheldon-data" 2>&1)
[[ $salida_sheldon == *'Aviso Sheldon: falta ~/.config/sheldon/plugins.toml; resuelve el conflicto de Dotbot y ejecuta ./bootstrap.'* ]]

cp "$RAIZ/home/config/sheldon/plugins.toml" "$TEMPORAL/sheldon-config/plugins.toml"
salida_sheldon=$(zsh -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- ":"; }
  SHELDON_CONFIG_DIR="$2"
  SHELDON_DATA_DIR="$3"
  source "$1"
' zsh "$RAIZ/home/.zshrc" "$TEMPORAL/sheldon-config" "$TEMPORAL/sheldon-data" 2>&1)
[[ $salida_sheldon == *'Aviso Sheldon: falta materializar el perfil base; ejecuta ./bootstrap.'* ]]

mkdir -p "$TEMPORAL/sheldon-data"
touch "$TEMPORAL/sheldon-data/plugins.base.lock"
salida_sheldon=$(zsh -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- ":"; }
  SHELDON_CONFIG_DIR="$2"
  SHELDON_DATA_DIR="$3"
  source "$1"
' zsh "$RAIZ/home/.zshrc" "$TEMPORAL/sheldon-config" "$TEMPORAL/sheldon-data" 2>&1)
[[ $salida_sheldon == *'Aviso Sheldon: falta materializar el perfil resaltado; ejecuta ./bootstrap.'* ]]

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

exec() { printf '%s\n' "$*" >>"$TEMPORAL/exec-zsh"; }
confirmar_recarga_sesion_zsh() { return 1; }
ofrecer_recarga_sesion_zsh
[[ ! -e $TEMPORAL/exec-zsh ]]

confirmar_recarga_sesion_zsh() { return 0; }
ofrecer_recarga_sesion_zsh
grep -Fqx "$TEMPORAL/bin/zsh -l" "$TEMPORAL/exec-zsh"
