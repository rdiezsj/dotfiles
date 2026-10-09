#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
trap 'estado=$?; printf "Fallo de zsh-terminal.sh en línea %s: %s\\n" "$LINENO" "$BASH_COMMAND" >&2; exit "$estado"' ERR
ZSH_BIN=$(command -v zsh)
PYTHON_BIN=$(command -v python || command -v python3)
export HOME="$TEMPORAL/home"
export ZDOTDIR="$TEMPORAL/zsh"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES_SKIP_BREW_SHELLENV=true
export LC_ALL=C
export TERM=xterm-256color
unset DOTFILES FPATH FZF_DEFAULT_OPTS SHELDON_CONFIG_DIR SHELDON_DATA_DIR
mkdir -p "$HOME/.config" "$HOME/.codex/skills/.system/runtime-skill" "$ZDOTDIR" "$TEMPORAL/bin"
printf '%s\n' 'skill gestionada por Codex' >"$HOME/.codex/skills/.system/runtime-skill/SKILL.md"

cat >"$TEMPORAL/bin/python" <<EOF
#!/usr/bin/env bash
exec "$PYTHON_BIN" "\$@"
EOF

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
cat >"$TEMPORAL/bin/kubectl" <<'EOF'
#!/usr/bin/env bash

[[ $1 == completion && $2 == zsh ]] || exit 1
printf '%s\n' ':'
EOF
cat >"$TEMPORAL/bin/fzf" <<'EOF'
#!/usr/bin/env bash

[[ $1 == --zsh ]] || exit 1
printf '%s\n' ':'
EOF
cat >"$TEMPORAL/bin/starship" <<'EOF'
#!/usr/bin/env bash

[[ $1 == init && $2 == zsh ]] || exit 1
printf '%s\n' ':'
EOF
chmod +x "$TEMPORAL/bin/kubectl" "$TEMPORAL/bin/fzf" "$TEMPORAL/bin/starship"
chmod +x "$TEMPORAL/bin/python"
export PATH="$TEMPORAL/bin:/usr/bin:/bin"

dconf_cargado=false
zellij_validado=false
dconf() {
  [[ $1 == load && $2 == /org/gnome/Ptyxis/ ]] || return 1
  cat >/dev/null
  dconf_cargado=true
}
gsettings() {
  [[ $1 == get ]] || return 1
  if [[ $2 == org.gnome.Ptyxis && $3 == default-profile-uuid ]]; then
    printf "'%s'\n" b3a9ca574b7b4bbd9c73a56c3e254ef4
  elif [[ $2 == org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/b3a9ca574b7b4bbd9c73a56c3e254ef4/ && $3 == palette ]]; then
    printf "'nord'\n"
  elif [[ $2 == org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/b3a9ca574b7b4bbd9c73a56c3e254ef4/ && $3 == limit-scrollback ]]; then
    printf '%s\n' false
  else
    return 1
  fi
}
zellij() {
  [[ $1 == setup && $2 == --check ]] || return 1
  [[ -n ${ZELLIJ_CONFIG_DIR:-} && -n ${ZELLIJ_SOCKET_DIR:-} ]]
  zellij_validado=true
}

# shellcheck source=/dev/null
source "$RAIZ/scripts/lib/zsh-terminal.sh"

"$ZSH_BIN" -n "$RAIZ/home/.zshrc" "$RAIZ/home/.zsh_aliases" "$RAIZ/home/.zsh_functions" "$RAIZ/home/.zprofile"
! grep -Ein 'token|secret|password|bw_session' "$RAIZ/home/.zshrc" "$RAIZ/home/.zsh_aliases" "$RAIZ/home/.zsh_functions" "$RAIZ/home/.profile" "$RAIZ/home/.zprofile" "$RAIZ/home/.config/starship.toml"
[[ $(grep -Ec '^rev = "[[:xdigit:]]{40}"$' "$RAIZ/home/.config/sheldon/plugins.toml") -eq 6 ]]
grep -Fqx 'profiles = ["base"]' "$RAIZ/home/.config/sheldon/plugins.toml"
grep -Fqx 'profiles = ["resaltado"]' "$RAIZ/home/.config/sheldon/plugins.toml"
! grep -Ein 'token|secret|password|bw_session' "$RAIZ/home/.config/sheldon/plugins.toml"
! grep -F 'sheldon lock --update' "$RAIZ/home/.zshrc"
grep -Fqx "alias activar-extensiones-gnome='\$HOME/.dotfiles/scripts/activar-extensiones-gnome.sh'" "$RAIZ/home/.zsh_aliases"
salida_no_interactiva=$("$ZSH_BIN" -fc 'source "$1"' zsh "$RAIZ/home/.zshrc")
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
for relativo in .nanorc .vimrc .gitconfig .gitignore .zshrc .zsh_aliases .zsh_functions .profile .zprofile .codex/AGENTS.md .codex/skills/alojamientos-viajes-familiares .codex/skills/exportar-en-formato-paradigma .codex/skills/humanizador .codex/skills/librarium-terra-notes .codex/skills/planificador-viajes-familiares .codex/skills/restaurantes-celiacos-seguros .config/starship.toml .config/sheldon/plugins.toml .config/terminator .local/bin/terminator .local/share/applications/terminator.desktop .config/ptyxis/config.dconf .config/zellij .config/flameshot/flameshot.ini .config/Heynote/config.json .config/Heynote/Preferences .config/input-remapper-2 .config/msmtp/config; do
  [[ -L $HOME/$relativo ]]
  if [[ $relativo == .config/* ]]; then
    [[ $(readlink -f "$HOME/$relativo") == "$RAIZ/home/.config/${relativo#.config/}" ]]
  elif [[ $relativo == .codex/* ]]; then
    [[ $(readlink -f "$HOME/$relativo") == "$RAIZ/home/.codex/${relativo#.codex/}" ]]
  else
    [[ $(readlink -f "$HOME/$relativo") == "$RAIZ/home/$relativo" ]]
  fi
done
[[ $dconf_cargado == true ]]
[[ $zellij_validado == true ]]
[[ -f $HOME/.config/zellij/config.kdl ]]
[[ -f $HOME/.config/terminator/plugins/.gitkeep ]]
[[ -f "$HOME/.config/input-remapper-2/presets/Logitech MX Master 3/cambio de escritorio.json" ]]
[[ -d $HOME/.codex/skills && ! -L $HOME/.codex/skills ]]
[[ -f $HOME/.codex/skills/.system/runtime-skill/SKILL.md ]]
[[ $(readlink -f "$HOME/.codex/skills/exportar-en-formato-paradigma") == "$RAIZ/home/.codex/skills/exportar-en-formato-paradigma" ]]

rm "$HOME/.codex/skills/exportar-en-formato-paradigma"
mkdir -p "$HOME/.codex/skills/exportar-en-formato-paradigma"
printf '%s\n' 'contenido local' >"$HOME/.codex/skills/exportar-en-formato-paradigma/propio.md"
confirmar_aplicacion_dotfile() { return 1; }
if configurar_archivos_zsh "$RAIZ"; then
  printf '%s\n' 'El directorio Codex no confirmado no detuvo Dotbot.' >&2
  exit 1
fi
grep -Fqx 'contenido local' "$HOME/.codex/skills/exportar-en-formato-paradigma/propio.md"
[[ ! -L $HOME/.codex/skills/exportar-en-formato-paradigma ]]
[[ -f $HOME/.codex/skills/.system/runtime-skill/SKILL.md ]]
confirmar_aplicacion_dotfile() { return 0; }
configurar_archivos_zsh "$RAIZ"
[[ -L $HOME/.codex/skills/exportar-en-formato-paradigma ]]
[[ -d $HOME/.codex/skills && ! -L $HOME/.codex/skills ]]
[[ -f $HOME/.codex/skills/.system/runtime-skill/SKILL.md ]]
respaldo_skills=$(find "$HOME/.dotfiles-backups" -type f -path '*/dotbot-*/*' -name propio.md -print -quit)
[[ -n $respaldo_skills ]]
grep -Fqx 'contenido local' "$respaldo_skills"

rm "$HOME/.config/terminator"
mkdir -p "$TEMPORAL/terminator-anterior"
ln -s "$TEMPORAL/terminator-anterior" "$HOME/.config/terminator"
configurar_archivos_zsh "$RAIZ"
[[ -L $HOME/.config/terminator ]]
[[ $(readlink -f "$HOME/.config/terminator") == "$RAIZ/home/.config/terminator" ]]
respaldo_terminator=$(find "$HOME/.dotfiles-backups" -type l -path '*/dotbot-*/*' -name terminator -print -quit)
[[ -n $respaldo_terminator ]]
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
[[ $(grep -Fc 'Configuración: archivos versionados enlazados mediante Dotbot' "$registro") == 4 ]]
grep -Fqx 'instalados:Sheldon: plugins Zsh materializados en el estado local' "$registro"
grep -Fqx 'presentes:Sheldon: estado local de plugins ya materializado' "$registro"
"$ZSH_BIN" -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- ":"; }
  source "$1"
  typeset -f extract | grep -Fq "Extract: no existe un archivo válido"
' zsh "$HOME/.zshrc"

mkdir -p "$HOME/.local/bin" "$HOME/.dotfiles/bin" "$HOME/.krew/bin"
"$ZSH_BIN" -dfic '
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
[[ $salida_conflicto == *"se rechazó el conflicto en $HOME/.gitconfig"* ]]
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

mkdir -p "$TEMPORAL/sheldon-config/sheldon"
salida_sheldon=$(XDG_CONFIG_HOME="$TEMPORAL" XDG_DATA_HOME="$TEMPORAL" "$ZSH_BIN" -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- ":"; }
  source "$1"
' zsh "$RAIZ/home/.zshrc" 2>&1)
[[ $salida_sheldon == *'Aviso Sheldon: falta ~/.config/sheldon/plugins.toml; resuelve el conflicto de Dotbot y ejecuta ./bootstrap.'* ]]

cp "$RAIZ/home/.config/sheldon/plugins.toml" "$TEMPORAL/sheldon-config/sheldon/plugins.toml"
salida_sheldon=$(XDG_CONFIG_HOME="$TEMPORAL/sheldon-config" XDG_DATA_HOME="$TEMPORAL" "$ZSH_BIN" -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- ":"; }
  source "$1"
' zsh "$RAIZ/home/.zshrc" 2>&1)
[[ $salida_sheldon == *'Aviso Sheldon: falta materializar el perfil base; ejecuta ./bootstrap.'* ]]

mkdir -p "$TEMPORAL/sheldon-data/sheldon"
touch "$TEMPORAL/sheldon-data/sheldon/plugins.base.lock"
salida_sheldon=$(XDG_CONFIG_HOME="$TEMPORAL/sheldon-config" XDG_DATA_HOME="$TEMPORAL/sheldon-data" "$ZSH_BIN" -dfic '
  sheldon() { [[ ${@: -1} == source ]] && print -r -- ":"; }
  source "$1"
' zsh "$RAIZ/home/.zshrc" 2>&1)
[[ $salida_sheldon == *'Aviso Sheldon: falta materializar el perfil resaltado; ejecuta ./bootstrap.'* ]]

printf '%s\n' '#!/usr/bin/env bash' 'exit 0' >"$TEMPORAL/bin/zsh"
chmod +x "$TEMPORAL/bin/zsh"
hash -r
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
ps() { return 1; }
confirmar_recarga_sesion_zsh() { return 1; }
ofrecer_recarga_sesion_zsh
[[ ! -e $TEMPORAL/exec-zsh ]]

confirmar_recarga_sesion_zsh() { return 0; }
ofrecer_recarga_sesion_zsh
grep -Fqx "$TEMPORAL/bin/zsh -l" "$TEMPORAL/exec-zsh"

rm -f "$TEMPORAL/exec-zsh"
confirmaciones_recarga=0
confirmar_recarga_sesion_zsh() {
  confirmaciones_recarga=$((confirmaciones_recarga + 1))
  return 1
}
ps() {
  [[ $1 == -p && $2 == "$PPID" && $3 == -o && $4 == comm= ]] || return 1
  printf '%s\n' zsh
}
ofrecer_recarga_sesion_zsh >"$TEMPORAL/salida-zsh"
[[ $confirmaciones_recarga -eq 0 ]]
[[ ! -e $TEMPORAL/exec-zsh ]]
grep -Fqx 'La sesión actual ya usa Zsh; no se abre una sesión adicional.' "$TEMPORAL/salida-zsh"

ps() { printf '%s\n' bash; }
ofrecer_recarga_sesion_zsh >"$TEMPORAL/salida-bash"
[[ $confirmaciones_recarga -eq 1 ]]
grep -Fqx 'Se mantiene la sesión actual; abre una nueva terminal para aplicar Zsh.' "$TEMPORAL/salida-bash"
