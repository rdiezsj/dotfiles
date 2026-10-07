#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

for archivo in \
  docs/index.md \
  docs/instalacion.md \
  docs/catalogo-fedora.md \
  docs/aplicaciones.md \
  docs/terminal.md \
  docs/vaultwarden.md \
  requirements-docs.txt; do
  [[ -f $RAIZ/$archivo ]]
done

for entrada in \
  'Instalación y verificación: instalacion.md' \
  'Catálogo por gestor: catalogo-fedora.md' \
  'Aplicaciones: aplicaciones.md' \
  'Terminal y Zsh: terminal.md' \
  'Vaultwarden y GNOME Keyring: vaultwarden.md'; do
  grep -Fqx "      - $entrada" "$RAIZ/mkdocs.yml"
done

for grupo in '## DNF/RPM' '## Homebrew' '## Flatpak (Flathub por usuario)' '## Extensiones GNOME' '## AppImage verificados'; do
  grep -Fqx "$grupo" "$RAIZ/docs/catalogo-fedora.md"
done

for extension in \
  'appindicatorsupport@rgcjonas.gmail.com' \
  'custom-hot-corners-extended@G-dH.github.com' \
  'clipboard-indicator@tudmotu.com' \
  'Vitals@CoreCoding.com' \
  'dash-to-dock@micxgx.gmail.com' \
  'gnome-shell-extension-appindicator' \
  'gnome-shell-extension-dash-to-dock' \
  'libgtop2-devel' \
  'lm_sensors'; do
  grep -Fq "$extension" "$RAIZ/docs/catalogo-fedora.md"
done

grep -Fq 'Si ya se ejecuta desde Zsh, conserva esa sesión y no solicita' "$RAIZ/docs/terminal.md"

if ! command -v mkdocs >/dev/null 2>&1 || ! python3 -c 'import material' >/dev/null 2>&1; then
  printf '%s\n' 'Documentación: instala pip install -r requirements-docs.txt para ejecutar mkdocs build --strict.'
  exit 0
fi

mkdocs build --strict --clean --config-file "$RAIZ/mkdocs.yml"
