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

URL_CHATGPT_X86_64='https://persistent.oaistatic.com/codex-app-prod/linux/rpm/latest/chatgpt.x86_64.rpm'
URL_CHATGPT_AARCH64='https://persistent.oaistatic.com/codex-app-prod/linux/rpm/latest/chatgpt.aarch64.rpm'
URL_FLATHUB='https://flathub.org/repo/flathub.flatpakrepo'
VERSIONES_FEDORA_CHATGPT=(43 44)
APP_ID_GEAR_LEVER='it.mijorus.gearlever'
ESQUEMA_GEAR_LEVER='it.mijorus.gearlever'
CLAVE_CARPETA_GEAR_LEVER='appimages-default-folder'

mostrar_bloque_catalogo() {
  local gestor=$1
  if declare -F mostrar_fase >/dev/null; then
    mostrar_fase "CATÁLOGO $gestor"
  else
    printf '\n[>] CATÁLOGO %s\n' "$gestor"
  fi
}

cargar_catalogos_software() {
  local directorio_catalogos=$1
  # shellcheck source=/dev/null
  source "$directorio_catalogos/dnf-rpm.sh"
  # shellcheck source=/dev/null
  source "$directorio_catalogos/homebrew.sh"
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

instalar_chatgpt() {
  local version_fedora arquitectura url
  if rpm -q chatgpt >/dev/null 2>&1; then
    registrar_catalogo presentes 'ChatGPT: ya estaba instalado'
    return 0
  fi
  version_fedora=$(rpm -E %fedora 2>/dev/null) || version_fedora=
  arquitectura=$(uname -m 2>/dev/null) || arquitectura=
  if [[ ! " ${VERSIONES_FEDORA_CHATGPT[*]} " == *" $version_fedora "* ]]; then
    registrar_catalogo omitidos "ChatGPT: Fedora ${version_fedora:-desconocida} no está admitida por OpenAI"
    return 0
  fi
  case $arquitectura in
    x86_64) url=$URL_CHATGPT_X86_64 ;;
    aarch64) url=$URL_CHATGPT_AARCH64 ;;
    *) registrar_catalogo omitidos "ChatGPT: arquitectura ${arquitectura:-desconocida} no admitida por OpenAI"; return 0 ;;
  esac
  if ! sudo dnf install -y "$url"; then
    registrar_catalogo fallidos 'ChatGPT: no se pudo instalar el RPM oficial'
    return 1
  fi
  if ! rpm -q chatgpt >/dev/null 2>&1; then
    registrar_catalogo fallidos 'ChatGPT: DNF terminó sin confirmar el paquete instalado'
    return 1
  fi
  registrar_catalogo instalados 'ChatGPT: RPM oficial instalado'
}

obtener_brew_catalogo() {
  if declare -F ruta_brew >/dev/null; then
    ruta_brew
    return
  fi
  command -v brew
}

instalar_paquete_homebrew() {
  local paquete=$1
  local brew
  brew=$(obtener_brew_catalogo) || {
    registrar_catalogo fallidos "Homebrew: no está disponible para instalar $paquete"
    return 1
  }
  if "$brew" list --versions "$paquete" >/dev/null 2>&1; then
    registrar_catalogo presentes "Homebrew: $paquete ya estaba instalado"
    return 0
  fi
  if "$brew" install "$paquete"; then
    registrar_catalogo instalados "Homebrew: $paquete instalado"
  else
    registrar_catalogo fallidos "Homebrew: no se pudo instalar $paquete"
    return 1
  fi
}

configurar_manifiesto_firefoxpwa() {
  local destino=${1:-/usr/lib/mozilla/native-messaging-hosts/firefoxpwa.json}
  local brew prefijo origen conector
  brew=$(obtener_brew_catalogo) || return 1
  prefijo=$("$brew" --prefix firefoxpwa) || return 1
  origen="$prefijo/share/firefoxpwa.json"
  if [[ ! -f $origen ]] || ! conector=$(jq -er 'select(.name == "firefoxpwa" and .type == "stdio") | .path | select(type == "string" and startswith("/"))' "$origen") || [[ ! -x $conector ]]; then
    registrar_catalogo fallidos 'Firefox PWA: manifiesto o conector nativo no disponible o inválido'
    return 1
  fi
  if [[ -L $destino && $destino -ef $origen ]]; then
    registrar_catalogo presentes 'Firefox PWA: manifiesto nativo ya enlazado'
    return 0
  fi
  if [[ -e $destino || -L $destino ]]; then
    registrar_catalogo fallidos "Firefox PWA: conflicto en $destino; se conserva el destino, revísalo antes de volver a ejecutar el bootstrap"
    return 1
  fi
  if ! sudo mkdir -p "$(dirname "$destino")" || ! sudo ln -s "$origen" "$destino"; then
    registrar_catalogo fallidos 'Firefox PWA: no se pudo enlazar el manifiesto nativo'
    return 1
  fi
  if [[ ! -L $destino || ! $destino -ef $origen ]]; then
    registrar_catalogo fallidos 'Firefox PWA: el enlace del manifiesto nativo no pudo verificarse'
    return 1
  fi
  registrar_catalogo instalados 'Firefox PWA: manifiesto nativo enlazado para la extensión de Firefox'
}

instalar_openspec_global() {
  local version
  if command -v openspec >/dev/null 2>&1 && version=$(openspec --version 2>/dev/null) && [[ -n $version ]]; then
    registrar_catalogo presentes "OpenSpec: CLI global funcional ($version)"
    return 0
  fi
  instalar_paquete_homebrew openspec
}

configurar_flathub() {
  local url_actual
  if url_actual=$(flatpak remote-get-url --user flathub 2>/dev/null); then
    [[ $url_actual == "$URL_FLATHUB" ]] && return 0
    flatpak remote-modify --user --url="$URL_FLATHUB" flathub
    return
  fi
  flatpak remote-add --user --if-not-exists flathub "$URL_FLATHUB"
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

configurar_carpeta_gear_lever() {
  local carpeta="$HOME/Apps"
  local valor_actual

  if ! flatpak info --user "$APP_ID_GEAR_LEVER" >/dev/null 2>&1; then
    registrar_catalogo fallidos 'Gear Lever: no está disponible para configurar la carpeta predeterminada'
    return 1
  fi
  mkdir -p "$carpeta"
  if ! valor_actual=$(flatpak run --command=gsettings "$APP_ID_GEAR_LEVER" get "$ESQUEMA_GEAR_LEVER" "$CLAVE_CARPETA_GEAR_LEVER"); then
    registrar_catalogo fallidos 'Gear Lever: no se pudo leer la carpeta predeterminada'
    return 1
  fi
  if [[ $valor_actual == "'$carpeta'" ]]; then
    registrar_catalogo presentes "Gear Lever: carpeta predeterminada ya configurada en $carpeta"
    return 0
  fi
  if ! flatpak run --command=gsettings "$APP_ID_GEAR_LEVER" set "$ESQUEMA_GEAR_LEVER" "$CLAVE_CARPETA_GEAR_LEVER" "$carpeta"; then
    registrar_catalogo fallidos 'Gear Lever: no se pudo configurar la carpeta predeterminada'
    return 1
  fi
  registrar_catalogo instalados "Gear Lever: carpeta predeterminada configurada en $carpeta"
}

verificar_fuse_appimage() {
  if ldconfig -p 2>/dev/null | grep -Fq 'libfuse.so.2'; then
    registrar_catalogo presentes 'FUSE: biblioteca libfuse.so.2 disponible para AppImage v2'
    return 0
  fi
  registrar_catalogo fallidos 'FUSE: falta libfuse.so.2 para ejecutar AppImage v2; revisa la instalación de fuse-libs'
  return 1
}

verificar_terminal() {
  local herramienta=$1
  local gestor=$2

  if command -v "$herramienta" >/dev/null 2>&1 && "$herramienta" --version >/dev/null 2>&1; then
    registrar_catalogo presentes "Terminal: $herramienta disponible"
    return 0
  fi
  registrar_catalogo fallidos "Terminal: $herramienta no está disponible tras el catálogo $gestor"
  return 1
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

reconciliar_aplicaciones_exclusivas_dnf() {
  retirar_firefox_snap_si_existe
  retirar_suites_ofimaticas_dnf
}

reconciliar_aplicaciones_exclusivas_flatpak() {
  local paquete
  for paquete in "${FLATPAK_EXCLUIDOS[@]}"; do
    retirar_flatpak_si_existe "$paquete"
  done
}

reconciliar_aplicaciones_exclusivas() {
  reconciliar_aplicaciones_exclusivas_dnf
  reconciliar_aplicaciones_exclusivas_flatpak
}

instalar_appimage() {
  local id=$1
  local destino="$HOME/Apps/${APPIMAGE_NOMBRE[$id]}"
  local temporal
  if [[ -e $destino ]]; then
    if [[ -f $destino ]] && printf '%s  %s\n' "${APPIMAGE_SHA256[$id]}" "$destino" | sha256sum -c - >/dev/null 2>&1; then
      registrar_catalogo presentes "AppImage: ${APPIMAGE_NOMBRE[$id]} ya estaba verificado"
      registrar_catalogo pendientes "Gear Lever: importa manualmente $destino"
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
  registrar_catalogo pendientes "Gear Lever: importa manualmente $destino"
}

habilitar_syncthing_usuario() {
  if ! rpm -q syncthing >/dev/null 2>&1; then
    registrar_catalogo omitidos 'Syncthing: servicio no habilitado porque el paquete no está instalado'
    return 0
  fi
  if systemctl --user is-enabled syncthing.service >/dev/null 2>&1; then
    registrar_catalogo presentes 'Syncthing: servicio de usuario ya habilitado'
    return 0
  fi
  if systemctl --user enable --now syncthing.service; then
    registrar_catalogo instalados 'Syncthing: servicio de usuario habilitado e iniciado'
  else
    registrar_catalogo fallidos 'Syncthing: no se pudo habilitar el servicio de usuario'
  fi
}

habilitar_input_remapper_sistema() {
  if ! rpm -q input-remapper >/dev/null 2>&1; then
    registrar_catalogo omitidos 'Input Remapper: servicio no habilitado porque el paquete no está instalado'
    return 0
  fi
  if systemctl is-enabled --quiet input-remapper.service >/dev/null 2>&1; then
    registrar_catalogo presentes 'Input Remapper: servicio de sistema ya habilitado'
    return 0
  fi
  if sudo systemctl enable --now input-remapper.service; then
    registrar_catalogo instalados 'Input Remapper: servicio de sistema habilitado e iniciado'
    return 0
  fi
  registrar_catalogo fallidos 'Input Remapper: no se pudo habilitar el servicio de sistema'
  return 1
}

ejecutar_catalogo_software() {
  local directorio_catalogos=$1
  local paquete
  cargar_catalogos_software "$directorio_catalogos"

  mostrar_bloque_catalogo 'DNF/RPM'
  reconciliar_aplicaciones_exclusivas_dnf
  for paquete in "${PAQUETES_DNF[@]}"; do
    instalar_paquete_dnf "$paquete" || true
  done
  verificar_fuse_appimage || true
  verificar_terminal ptyxis DNF || true
  instalar_chatgpt || true
  habilitar_syncthing_usuario

  mostrar_bloque_catalogo 'HOMEBREW'
  for paquete in "${PAQUETES_HOMEBREW[@]}"; do
    if [[ $paquete == openspec ]]; then
      instalar_openspec_global || true
    elif [[ $paquete == firefoxpwa ]]; then
      if instalar_paquete_homebrew "$paquete"; then
        configurar_manifiesto_firefoxpwa || true
      fi
    else
      instalar_paquete_homebrew "$paquete" || true
    fi
  done
  verificar_terminal zellij Homebrew || true

  mostrar_bloque_catalogo 'FLATPAK'
  reconciliar_aplicaciones_exclusivas_flatpak
  configurar_flathub
  for paquete in "${PAQUETES_FLATPAK[@]}"; do
    instalar_paquete_flatpak "$paquete" || true
  done
  configurar_carpeta_gear_lever || true

  mostrar_bloque_catalogo 'APPIMAGE'
  for paquete in "${PAQUETES_APPIMAGE[@]}"; do
    instalar_appimage "$paquete" || true
  done
}
