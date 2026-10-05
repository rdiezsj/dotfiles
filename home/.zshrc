# Configuración interactiva versionada de Zsh.

[[ -o interactive ]] || return

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}"
setopt append_history hist_ignore_dups hist_reduce_blanks share_history

[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"

if command -v brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

export SHELDON_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon"
export SHELDON_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/sheldon"

if command -v sheldon >/dev/null 2>&1 \
  && [[ -f "$SHELDON_CONFIG_DIR/plugins.toml" ]] \
  && [[ -f "$SHELDON_DATA_DIR/plugins.base.lock" ]]; then
  eval "$(sheldon --profile base source)"
elif command -v sheldon >/dev/null 2>&1; then
  print -u2 -- 'Aviso: los plugins Sheldon aún no están materializados; ejecuta el bootstrap.'
fi

# Las utilidades locales sustituyen las variantes genéricas de los plugins.
[[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"

autoload -Uz compinit
compinit

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v sheldon >/dev/null 2>&1 \
  && [[ -f "$SHELDON_CONFIG_DIR/plugins.toml" ]] \
  && [[ -f "$SHELDON_DATA_DIR/plugins.resaltado.lock" ]]; then
  eval "$(sheldon --profile resaltado source)"
fi
