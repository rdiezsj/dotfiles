# Configuración interactiva versionada de Zsh.

[[ -o interactive ]] || return 0

# Las pruebas desactivan esta inicialización para no heredar el Homebrew del equipo.
if [[ ${DOTFILES_SKIP_BREW_SHELLENV:-false} != true && -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
typeset -U path PATH

_dotfiles_extender_path() {
  local directorio=$1
  [[ -d $directorio ]] || return 0
  path=("$directorio" $path)
}

# Rutas personales; Homebrew configura sus propias rutas con brew shellenv.
_dotfiles_extender_path "$HOME/.local/bin"
_dotfiles_extender_path "$DOTFILES/bin"
_dotfiles_extender_path "$HOME/.krew/bin"

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}"
setopt append_history hist_ignore_dups hist_reduce_blanks share_history

[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"

bindkey -e
: "${FZF_DEFAULT_OPTS:=}"

_dotfiles_anadir_opcion_fzf() {
  local opcion=$1
  case " $FZF_DEFAULT_OPTS " in
    *" $opcion "*) ;;
    *) FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }$opcion" ;;
  esac
}

_dotfiles_anadir_opcion_fzf '--height 40%'
_dotfiles_anadir_opcion_fzf '--layout=reverse'
_dotfiles_anadir_opcion_fzf '--border'
export FZF_DEFAULT_OPTS

if command -v brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

export SHELDON_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon"
export SHELDON_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/sheldon"

if command -v sheldon >/dev/null 2>&1; then
  if [[ ! -f "$SHELDON_CONFIG_DIR/plugins.toml" ]]; then
    print -u2 -- 'Aviso Sheldon: falta ~/.config/sheldon/plugins.toml; resuelve el conflicto de Dotbot y ejecuta ./bootstrap.'
  elif [[ ! -f "$SHELDON_DATA_DIR/plugins.base.lock" ]]; then
    print -u2 -- 'Aviso Sheldon: falta materializar el perfil base; ejecuta ./bootstrap.'
  else
    eval "$(sheldon --profile base source)"
  fi
fi

# Las utilidades locales sustituyen las variantes genéricas de los plugins.
[[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"

autoload -Uz compinit
compinit

if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v sheldon >/dev/null 2>&1 && [[ -f "$SHELDON_CONFIG_DIR/plugins.toml" ]]; then
  if [[ -f "$SHELDON_DATA_DIR/plugins.resaltado.lock" ]]; then
    eval "$(sheldon --profile resaltado source)"
  elif [[ -f "$SHELDON_DATA_DIR/plugins.base.lock" ]]; then
    print -u2 -- 'Aviso Sheldon: falta materializar el perfil resaltado; ejecuta ./bootstrap.'
  fi
fi
