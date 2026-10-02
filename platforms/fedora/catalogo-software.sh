#!/usr/bin/env bash

# Reconcilia el catálogo base de Fedora sin reemplazar datos de aplicaciones.

registrar_catalogo() {
  local categoria=$1
  local mensaje=$2
  if declare -F registrar_resultado >/dev/null; then
    registrar_resultado "$categoria" "$mensaje"
  else
    printf '[%s] %s\n' "$categoria" "$mensaje"
  fi
}

cargar_catalogos_software() {
  local directorio_catalogos=$1
  # shellcheck source=/dev/null
  source "$directorio_catalogos/dnf-rpm.sh"
  # shellcheck source=/dev/null
  source "$directorio_catalogos/flatpak.sh"
  # shellcheck source=/dev/null
  source "$directorio_catalogos/appimage.sh"
}

instalar_paquete_dnf() {
  local paquete=$1
  if rpm -q "$paquete" >/dev/null 2>&1; then
    registrar_catalogo presentes "DNF: $paquete ya estaba instalado"
    return 0
  fi
  if sudo dnf install -y "$paquete"; then
    registrar_catalogo instalados "DNF: $paquete instalado"
  else
    registrar_catalogo fallidos "DNF: no se pudo instalar $paquete"
    return 1
  fi
}

configurar_flathub() {
  if flatpak remote-get-url --user flathub >/dev/null 2>&1; then
    return 0
  fi
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

instalar_paquete_flatpak() {
  local paquete=$1
  if flatpak info --user "$paquete" >/dev/null 2>&1; then
    registrar_catalogo presentes "Flatpak: $paquete ya estaba instalado"
    return 0
  fi
  if flatpak install --user -y flathub "$paquete"; then
    registrar_catalogo instalados "Flatpak: $paquete instalado"
  else
    registrar_catalogo fallidos "Flatpak: no se pudo instalar $paquete"
    return 1
  fi
}

retirar_flatpak_si_existe() {
  local paquete=$1
  if flatpak info --user "$paquete" >/dev/null 2>&1; then
    flatpak uninstall --user -y "$paquete"
    registrar_catalogo instalados "Flatpak: variante excluida $paquete retirada"
  fi
}

retirar_firefox_snap_si_existe() {
  if command -v snap >/dev/null 2>&1 && snap list firefox >/dev/null 2>&1; then
    sudo snap remove firefox
    registrar_catalogo instalados 'Snap: variante Firefox retirada'
  fi
}

retirar_suites_ofimaticas_dnf() {
  local -a instalados=()
  local paquete
  while IFS= read -r paquete; do
    [[ -n $paquete ]] && instalados+=("$paquete")
  done < <(rpm -qa --qf '%{NAME}\n' 'libreoffice*' 'softmaker-freeoffice*' 2>/dev/null | sort -u)
  if (( ${#instalados[@]} > 0 )); then
    sudo dnf remove -y "${instalados[@]}"
    registrar_catalogo instalados 'DNF: variantes LibreOffice/FreeOffice retiradas'
  fi
}

reconciliar_aplicaciones_exclusivas() {
  local paquete
  retirar_firefox_snap_si_existe
  for paquete in "${FLATPAK_EXCLUIDOS[@]}"; do
    retirar_flatpak_si_existe "$paquete"
  done
  retirar_suites_ofimaticas_dnf
}

instalar_appimage() {
  local id=$1
  local destino="$HOME/Apps/${APPIMAGE_NOMBRE[$id]}"
  local temporal
  if [[ -e $destino ]]; then
    if [[ -f $destino ]] && printf '%s  %s\n' "${APPIMAGE_SHA256[$id]}" "$destino" | sha256sum -c - >/dev/null 2>&1; then
      registrar_catalogo presentes "AppImage: ${APPIMAGE_NOMBRE[$id]} ya estaba verificado"
      return 0
    fi
    registrar_catalogo pendientes "AppImage: conflicto en $destino; no se reemplazó"
    return 0
  fi
  mkdir -p "$HOME/Apps"
  temporal=$(mktemp "$HOME/Apps/.${id}.XXXXXX")
  if ! curl --fail --location --retry 3 --output "$temporal" "${APPIMAGE_URL[$id]}"; then
    rm -f "$temporal"
    registrar_catalogo fallidos "AppImage: no se pudo descargar ${APPIMAGE_NOMBRE[$id]}"
    return 1
  fi
  if ! printf '%s  %s\n' "${APPIMAGE_SHA256[$id]}" "$temporal" | sha256sum -c - >/dev/null; then
    rm -f "$temporal"
    registrar_catalogo fallidos "AppImage: suma SHA-256 inválida para ${APPIMAGE_NOMBRE[$id]}"
    return 1
  fi
  install -m 0755 "$temporal" "$destino"
  rm -f "$temporal"
  registrar_catalogo instalados "AppImage: ${APPIMAGE_NOMBRE[$id]} instalado"
}

habilitar_syncthing_usuario() {
  if systemctl --user is-enabled syncthing.service >/dev/null 2>&1; then
    registrar_catalogo presentes 'Syncthing: servicio de usuario ya habilitado'
    return 0
  fi
  systemctl --user enable --now syncthing.service
  registrar_catalogo instalados 'Syncthing: servicio de usuario habilitado e iniciado'
}

ejecutar_catalogo_software() {
  local directorio_catalogos=$1
  local paquete
  cargar_catalogos_software "$directorio_catalogos"
  reconciliar_aplicaciones_exclusivas
  for paquete in "${PAQUETES_DNF[@]}"; do
    instalar_paquete_dnf "$paquete"
  done
  configurar_flathub
  for paquete in "${PAQUETES_FLATPAK[@]}"; do
    instalar_paquete_flatpak "$paquete"
  done
  for paquete in "${PAQUETES_APPIMAGE[@]}"; do
    instalar_appimage "$paquete"
  done
  habilitar_syncthing_usuario
}
