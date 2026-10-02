#!/usr/bin/env bash

# Dependencias mínimas del bootstrap. Python permite ejecutar Dotbot cuando se
# incorpore su código gestionado al repositorio.

DEPENDENCIAS_MINIMAS=(git curl zsh flatpak gum python3 libsecret)

dependencia_disponible() {
  command -v "$1" >/dev/null 2>&1
}

dependencias_ausentes() {
  local dependencia
  for dependencia in "${DEPENDENCIAS_MINIMAS[@]}"; do
    if ! dependencia_disponible "$dependencia"; then
      printf '%s\n' "$dependencia"
    fi
  done
}

instalar_dependencias_minimas() {
  local -a ausentes=()
  mapfile -t ausentes < <(dependencias_ausentes)
  if (( ${#ausentes[@]} == 0 )); then
    printf '%s\n' 'Dependencias mínimas ya satisfechas.'
    return 0
  fi
  printf 'Instalando dependencias mínimas: %s\n' "${ausentes[*]}"
  sudo dnf install -y "${ausentes[@]}"
}
