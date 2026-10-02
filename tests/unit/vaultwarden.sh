#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT

cat >"$TEMPORAL/bw" <<'EOF'
#!/usr/bin/env bash
case "$1 $2" in
  'config server') printf '%s\n' "$*" >"$BW_PRUEBA_SALIDA" ;;
  'unlock --raw') printf '%s\n' 'sesion-de-prueba' ;;
  'list folders') test "${BW_SESSION:-}" = sesion-de-prueba ;;
esac
EOF
cat >"$TEMPORAL/secret-tool" <<'EOF'
#!/usr/bin/env bash
if [[ $1 == store ]]; then
  cat >"$BW_PRUEBA_SESION"
elif [[ $1 == lookup ]]; then
  cat "$BW_PRUEBA_SESION"
fi
EOF
chmod +x "$TEMPORAL/bw"
chmod +x "$TEMPORAL/secret-tool"

# shellcheck source=/dev/null
source "$RAIZ/platforms/fedora/vaultwarden.sh"
export PATH="$TEMPORAL:/usr/bin:/bin"
export BW_PRUEBA_SALIDA="$TEMPORAL/salida"
export BW_PRUEBA_SESION="$TEMPORAL/sesion"
configurar_vaultwarden 'https://vaultwarden.example.invalid'
[[ $(<"$TEMPORAL/salida") == 'config server https://vaultwarden.example.invalid' ]]
[[ $(<"$TEMPORAL/sesion") == sesion-de-prueba ]]

rm "$TEMPORAL/bw"
hash -r
cat >"$TEMPORAL/brew" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >"$BW_PRUEBA_BREW"
EOF
chmod +x "$TEMPORAL/brew"
export BW_PRUEBA_BREW="$TEMPORAL/brew.log"
preparar_bitwarden_cli
[[ $(<"$TEMPORAL/brew.log") == 'install bitwarden-cli' ]]
