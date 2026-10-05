#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TEMPORAL=$(mktemp -d)
trap 'rm -rf "$TEMPORAL"' EXIT
export HOME="$TEMPORAL/home"
export USER=prueba
export SESION_PRUEBA=sesion-valida
mkdir -p "$HOME" "$TEMPORAL/bin"

cat >"$TEMPORAL/bin/secret-tool" <<'EOF'
#!/usr/bin/env bash

if [[ ${1:-} == lookup && -n ${SESION_PRUEBA:-} ]]; then
  printf '%s\n' "$SESION_PRUEBA"
  exit 0
fi
exit 1
EOF

cat >"$TEMPORAL/bin/bw" <<'EOF'
#!/usr/bin/env bash

[[ ${BW_SESSION:-} == sesion-valida ]] || exit 1
case "$*" in
  'list folders --raw') printf '%s\n' '[]' ;;
  'get username Mail.ionos.es') printf '%s\n' 'fedora_desktop@rdiez.es' ;;
  'get password Mail.ionos.es') printf '%s\n' 'contrasena-de-prueba' ;;
  *) exit 1 ;;
esac
EOF
chmod +x "$TEMPORAL/bin/secret-tool" "$TEMPORAL/bin/bw"
export PATH="$TEMPORAL/bin:$PATH"

usuario=$("$RAIZ/bin/msmtp-obtener-usuario")
[[ $usuario == 'user "fedora_desktop@rdiez.es"' ]]
contrasena=$("$RAIZ/bin/msmtp-obtener-contrasena")
[[ $contrasena == contrasena-de-prueba ]]
[[ -d $HOME/.local/state/msmtp ]]

export SESION_PRUEBA=
if salida=$("$RAIZ/bin/msmtp-obtener-contrasena" 2>&1); then
  printf '%s\n' 'La ausencia de sesión no bloqueó la obtención SMTP.' >&2
  exit 1
fi
[[ $salida == *'Vaultwarden está bloqueado'* ]]
[[ $salida != *sesion-valida* ]]

export SESION_PRUEBA=sesion-caducada
if salida=$("$RAIZ/bin/msmtp-obtener-contrasena" 2>&1); then
  printf '%s\n' 'La sesión caducada no bloqueó la obtención SMTP.' >&2
  exit 1
fi
[[ $salida == *'sesión de Vaultwarden no es válida'* ]]
[[ $salida != *sesion-caducada* ]]
