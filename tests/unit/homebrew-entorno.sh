#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

mkdir -p "$TEMPORAL/bin" "$TEMPORAL/home"
printf '%s\n' '# Contenido personal de Bash' >"$TEMPORAL/home/.bashrc"

cat >"$TEMPORAL/bin/brew" <<'EOF'
#!/usr/bin/env bash
if [[ $1 == shellenv ]]; then
  printf 'export PATH="%s:$PATH"\n' "$HOMEBREW_PRUEBA_BIN"
fi
EOF
cat >"$TEMPORAL/bin/sudo" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$HOMEBREW_PRUEBA_SUDO"
EOF
chmod +x "$TEMPORAL/bin/brew" "$TEMPORAL/bin/sudo"

# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/fuentes-externas.sh"
export PATH="$TEMPORAL/bin:$PATH"
export HOMEBREW_PRUEBA_BIN="$TEMPORAL/bin"
export HOMEBREW_PRUEBA_SUDO="$TEMPORAL/sudo.log"

HOME="$TEMPORAL/home" instalar_homebrew
HOME="$TEMPORAL/home" instalar_homebrew

[[ $(<"$TEMPORAL/home/.bashrc") == *'# Contenido personal de Bash'* ]]
[[ $(grep -Fc '# >>> dotfiles: Homebrew >>>' "$TEMPORAL/home/.bashrc") == 1 ]]
linea_bash=$(printf 'eval "$(%s shellenv bash)"' "$TEMPORAL/bin/brew")
grep -Fqx "$linea_bash" "$TEMPORAL/home/.bashrc"
[[ ! -e $TEMPORAL/home/.zshrc ]]
grep -Fqx 'dnf group install -y development-tools' "$TEMPORAL/sudo.log"
