#!/usr/bin/env bash

set -euo pipefail

RAIZ=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

grep -Fqx 'useDefault = true' "$RAIZ/gitleaks.toml"
grep -Fqx '  - repo: https://github.com/gitleaks/gitleaks' "$RAIZ/.pre-commit-config.yaml"
grep -Fqx '    rev: v8.30.1' "$RAIZ/.pre-commit-config.yaml"
grep -Fqx '      - id: gitleaks' "$RAIZ/.pre-commit-config.yaml"

flujo=$RAIZ/.github/workflows/secretos.yml
grep -Fqx '  pull_request:' "$flujo"
grep -Fqx '    branches: [main]' "$flujo"
grep -Fqx '  push:' "$flujo"
grep -Fqx '  workflow_dispatch:' "$flujo"
grep -Fqx '          fetch-depth: 0' "$flujo"
grep -Fqx '          GITLEAKS_CONFIG: gitleaks.toml' "$flujo"
grep -Fqx '          GITLEAKS_ENABLE_COMMENTS: false' "$flujo"
grep -Fqx '          GITLEAKS_ENABLE_UPLOAD_ARTIFACT: false' "$flujo"
grep -Fqx '          GITLEAKS_VERSION: 8.30.1' "$flujo"
grep -Eq '^      - uses: actions/checkout@[0-9a-f]{40} # v6\.1\.0$' "$flujo"
grep -Eq '^      - uses: gitleaks/gitleaks-action@[0-9a-f]{40} # v3\.0\.0$' "$flujo"

pre-commit validate-config "$RAIZ/.pre-commit-config.yaml"
pre-commit run --config "$RAIZ/.pre-commit-config.yaml" --all-files

temporal=$(mktemp -d)
trap 'rm -rf "$temporal"' EXIT
git -C "$temporal" init --quiet
git -C "$temporal" config user.email test@example.invalid
git -C "$temporal" config user.name test
cp "$RAIZ/.pre-commit-config.yaml" "$RAIZ/gitleaks.toml" "$temporal"/
git -C "$temporal" add .pre-commit-config.yaml gitleaks.toml
git -C "$temporal" commit --quiet --no-verify -m inicial

valor='a7X2mQ9pL4vR8kN1sT6wY3cD5fG0hJ7q'
printf 'api_key = "%s"\n' "$valor" >"$temporal/credencial-sintetica.txt"
git -C "$temporal" add credencial-sintetica.txt
if salida=$(cd "$temporal" && pre-commit run --hook-stage pre-commit --all-files 2>&1); then
  printf '%s\n' 'Gitleaks aceptó una credencial sintética.' >&2
  exit 1
fi
[[ $salida == *'Detect hardcoded secrets'* ]]
[[ $salida != *"$valor"* ]]
