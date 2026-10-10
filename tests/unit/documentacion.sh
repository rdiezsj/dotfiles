#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

for archivo in \
  docs/index.md \
  docs/instalacion.md \
  docs/catalogo-fedora.md \
  docs/aplicaciones.md \
  docs/terminal.md \
  docs/automatizacion.md \
  docs/vaultwarden.md \
  docs/seguridad.md \
  requirements-docs.txt; do
  [[ -f $RAIZ/$archivo ]]
done

for pendiente in \
  'Configuración de tema y apariencia para Zellij.' \
  'Atajos de teclado.' \
  'Scripts de actualización.' \
  'Wiki de GitHub.' \
  'Escaneo local y en CI para prevenir secretos versionados.' \
  'Diagnóstico de solo lectura `dotfiles doctor` para detectar deriva de configuración.' \
  'Validación del bootstrap en una estación Fedora de destino para Ptyxis y Zellij.' \
  'Actualización verificable de Nextcloud AppImage mediante su firma publicada.'; do
  grep -Fqx -- "- $pendiente" "$RAIZ/README.md"
done

grep -Fqx '[![Publicar documentación](https://github.com/rdiezsj/dotfiles/actions/workflows/documentation.yml/badge.svg?branch=main&event=push)](https://github.com/rdiezsj/dotfiles/actions/workflows/documentation.yml)' "$RAIZ/README.md"
grep -Fqx '[![Analizar secretos](https://github.com/rdiezsj/dotfiles/actions/workflows/secretos.yml/badge.svg?branch=main&event=push)](https://github.com/rdiezsj/dotfiles/actions/workflows/secretos.yml)' "$RAIZ/README.md"
grep -Fqx '[![Validar repositorio](https://github.com/rdiezsj/dotfiles/actions/workflows/validar-repositorio.yml/badge.svg?branch=main&event=push)](https://github.com/rdiezsj/dotfiles/actions/workflows/validar-repositorio.yml)' "$RAIZ/README.md"

for entrada in \
  'Instalación y verificación: instalacion.md' \
  'Catálogo por gestor: catalogo-fedora.md' \
  'Aplicaciones: aplicaciones.md' \
  'Terminal y Zsh: terminal.md' \
  'Workflows de GitHub Actions: automatizacion.md' \
  'Vaultwarden y GNOME Keyring: vaultwarden.md' \
  'Prevención de secretos: seguridad.md'; do
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
grep -Fq '~/.dotfiles/scripts/actualizar.sh' "$RAIZ/docs/instalacion.md"
grep -Fq 'activar-extensiones-gnome' "$RAIZ/docs/instalacion.md"
grep -Fq 'activar-extensiones-gnome' "$RAIZ/docs/catalogo-fedora.md"
grep -Fq 'sin confirmaciones propias' "$RAIZ/docs/instalacion.md"
grep -Fq 'SHA-256 verificable' "$RAIZ/docs/instalacion.md"
grep -Fq 'usa `Adwaita:dark` solo para Terminator' "$RAIZ/docs/catalogo-fedora.md"
grep -Fq '| Ptyxis | Terminal principal de GNOME.' "$RAIZ/docs/catalogo-fedora.md"
grep -Fq '| Zellij | Multiplexor de terminal con paneles.' "$RAIZ/docs/catalogo-fedora.md"
grep -Fq '[Zellij en Homebrew](https://formulae.brew.sh/formula/zellij)' "$RAIZ/docs/catalogo-fedora.md"
awk '
  /^## DNF\/RPM$/ { seccion="dnf"; next }
  /^## Homebrew$/ { seccion="homebrew"; next }
  /^## / { seccion="" }
  /^\| Zellij \|/ && seccion == "homebrew" { encontrado=1 }
  /^\| Zellij \|/ && seccion == "dnf" { exit 1 }
  END { exit !encontrado }
' "$RAIZ/docs/catalogo-fedora.md"
grep -Fq 'conserva `Ctrl+P`, `D` y `R`' "$RAIZ/docs/catalogo-fedora.md"
grep -Fq '| dconf | Herramienta de configuración para aplicaciones GNOME.' "$RAIZ/docs/catalogo-fedora.md"
grep -Fq '~/.local/share/applications/terminator.desktop' "$RAIZ/docs/aplicaciones.md"
grep -Fq 'cierra todas sus ventanas antes de abrirlo' "$RAIZ/docs/aplicaciones.md"
grep -Fq '~/.config/ptyxis/config.dconf' "$RAIZ/docs/aplicaciones.md"
grep -Fq '~/.config/zellij/' "$RAIZ/docs/aplicaciones.md"
grep -Fq 'Ctrl+P`, seguido de `D` o `R`' "$RAIZ/docs/aplicaciones.md"
grep -Fqx '# Automatización' "$RAIZ/docs/automatizacion.md"
grep -Fq '## Validar repositorio' "$RAIZ/docs/automatizacion.md"
grep -Fq '## Analizar secretos' "$RAIZ/docs/automatizacion.md"
grep -Fq '## Publicar documentación' "$RAIZ/docs/automatizacion.md"
grep -Fq 'bash scripts/check.sh' "$RAIZ/docs/automatizacion.md"
grep -Fq 'pre-commit run --all-files' "$RAIZ/docs/automatizacion.md"
grep -Fq 'instala explícitamente `zsh`, `7z`, `jq`' "$RAIZ/docs/automatizacion.md"
grep -Fqx -- '- [Workflows de GitHub Actions](docs/automatizacion.md)' "$RAIZ/README.md"

if ! command -v mkdocs >/dev/null 2>&1 || ! python3 -c 'import material' >/dev/null 2>&1; then
  printf '%s\n' 'Documentación: instala pip install -r requirements-docs.txt para ejecutar mkdocs build --strict.'
  exit 0
fi

mkdocs build --strict --clean --config-file "$RAIZ/mkdocs.yml"
