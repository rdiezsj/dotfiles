#!/usr/bin/env bash

# Rutinas no interactivas para mantener una estación ya desplegada.

actualizar_checkout_dotfiles() {
  local raiz=$1 referencia remoto
  [[ -d $raiz/.git ]] || { registrar_resultado fallidos "Git: $raiz no es un checkout de dotfiles"; return 1; }
  if ! git -C "$raiz" diff --quiet || ! git -C "$raiz" diff --cached --quiet; then
    registrar_resultado fallidos 'Git: el checkout tiene cambios locales; no se sobrescribió'
    return 1
  fi
  referencia=${DOTFILES_REF:-$(git -C "$raiz" branch --show-current)}
  [[ -n $referencia ]] || { registrar_resultado fallidos 'Git: no se pudo determinar la referencia actual'; return 1; }
  remoto=${DOTFILES_REMOTE:-origin}
  git -C "$raiz" fetch "$remoto" "$referencia" && git -C "$raiz" merge --ff-only FETCH_HEAD || {
    registrar_resultado fallidos "Git: no se pudo actualizar mediante avance rápido ($remoto/$referencia)"
    return 1
  }
  registrar_resultado instalados "Git: checkout sincronizado con $remoto/$referencia"
}

actualizar_configuraciones_dotbot() {
  local raiz=$1 destino origen
  # shellcheck source=/dev/null
  source "$raiz/scripts/lib/zsh-terminal.sh"
  while IFS= read -r destino; do
    origen=$(origen_dotfile "$raiz" "$destino")
    if [[ -e $destino || -L $destino ]] && ! destino_zsh_gestionado "$raiz" "$destino"; then
      registrar_resultado fallidos "Dotbot: conflicto local conservado en $destino"
      return 1
    fi
  done < <(listar_destinos_dotbot)
  if ejecutar_dotbot_zsh "$raiz"; then
    registrar_resultado instalados 'Dotbot: configuraciones versionadas aplicadas'
    return 0
  fi
  registrar_resultado fallidos 'Dotbot: no se pudieron aplicar las configuraciones versionadas'
  return 1
}

actualizar_dnf() {
  if sudo dnf upgrade --refresh -y; then
    registrar_resultado instalados 'DNF: metadatos, repositorios y paquetes actualizados'
  else
    registrar_resultado fallidos 'DNF: no se pudo completar la actualización'
    return 1
  fi
  if sudo dnf needs-restarting -r >/dev/null 2>&1; then
    :
  elif [[ $? -eq 1 ]]; then
    registrar_resultado pendientes 'DNF: se recomienda reiniciar para usar todas las actualizaciones'
  fi
}

actualizar_homebrew() {
  local brew
  brew=$(command -v brew) || { registrar_resultado fallidos 'Homebrew: no está disponible'; return 1; }
  "$brew" update && "$brew" upgrade || { registrar_resultado fallidos 'Homebrew: no se pudo completar la actualización'; return 1; }
  registrar_resultado instalados 'Homebrew: fórmulas actualizadas'
}

actualizar_flatpak() {
  if flatpak update --user -y; then
    registrar_resultado instalados 'Flatpak: aplicaciones de usuario actualizadas'
  else
    registrar_resultado fallidos 'Flatpak: no se pudo completar la actualización'
    return 1
  fi
}

actualizar_extensiones_gnome() {
  local raiz=$1 id uuid version url temporal
  # shellcheck source=/dev/null
  source "$raiz/platforms/fedora/extensiones-gnome.sh"
  version=$(obtener_version_gnome_shell) || { registrar_resultado fallidos 'Extensiones GNOME: no se pudo detectar GNOME Shell'; return 1; }
  for id in "${EXTENSIONES_GNOME[@]}"; do
    [[ ${EXTENSION_GNOME_ORIGEN[$id]} == extensions.gnome.org ]] || continue
    uuid=${EXTENSION_GNOME_UUID[$id]}
    url=$(obtener_url_extension_gnome "$uuid" "$version") || { registrar_resultado fallidos "Extensiones GNOME: $id no tiene una versión compatible"; return 1; }
    temporal=$(mktemp "${TMPDIR:-/tmp}/extension-gnome.XXXXXX.zip") || return 1
    if ! curl --fail --location --silent --show-error --output "$temporal" "$url" \
      || ! gnome-extensions install --force "$temporal" >/dev/null 2>&1; then
      rm -f "$temporal"
      registrar_resultado fallidos "Extensiones GNOME: no se pudo actualizar $id"
      return 1
    fi
    rm -f "$temporal"
    registrar_resultado instalados "Extensiones GNOME: $id actualizada"
  done
}

actualizar_appimages() {
  local raiz=$1 id
  # shellcheck source=/dev/null
  source "$raiz/catalogs/appimage.sh"
  for id in "${PAQUETES_APPIMAGE[@]}"; do
    actualizar_appimage_declarado "$id" || return 1
  done
}

obtener_metadatos_appimage() {
  local id=$1 manifiesto=$2
  curl --fail --silent --show-error --location "$manifiesto" | python3 -c '
import json
import sys

release = json.load(sys.stdin)
for asset in release.get("assets", []):
    name = asset.get("name", "")
    digest = asset.get("digest", "")
    url = asset.get("browser_download_url", "")
    if name.endswith(".AppImage") and digest.startswith("sha256:") and url.startswith("https://"):
        print(name, url, digest.removeprefix("sha256:"), sep="\t")
        break
else:
    raise SystemExit(1)
'
}

actualizar_appimage_declarado() {
  local id=$1 manifiesto nombre url suma destino temporal
  manifiesto=${APPIMAGE_MANIFIESTO_GITHUB[$id]:-}
  if [[ -z $manifiesto ]]; then
    registrar_resultado omitidos "AppImage: $id conserva la versión declarada; no hay manifiesto de actualización verificable"
    return 0
  fi
  IFS=$'\t' read -r nombre url suma < <(obtener_metadatos_appimage "$id" "$manifiesto") || {
    registrar_resultado fallidos "AppImage: no se pudieron verificar los metadatos oficiales de $id"
    return 1
  }
  [[ $suma =~ ^[[:xdigit:]]{64}$ ]] || { registrar_resultado fallidos "AppImage: suma SHA-256 inválida para $id"; return 1; }
  destino="$HOME/Apps/$nombre"
  if [[ -f $destino ]] && printf '%s  %s\n' "$suma" "$destino" | sha256sum -c - >/dev/null 2>&1; then
    registrar_resultado presentes "AppImage: $nombre ya estaba actualizado"
    return 0
  fi
  mkdir -p "$HOME/Apps"
  temporal=$(mktemp "$HOME/Apps/.${id}.XXXXXX") || return 1
  if ! curl --fail --location --retry 3 --output "$temporal" "$url" \
    || ! printf '%s  %s\n' "$suma" "$temporal" | sha256sum -c - >/dev/null 2>&1; then
    rm -f "$temporal"
    registrar_resultado fallidos "AppImage: no se pudo verificar la actualización de $id"
    return 1
  fi
  chmod 0755 "$temporal"
  mv -f "$temporal" "$destino"
  registrar_resultado instalados "AppImage: $nombre actualizado y verificado"
}

ejecutar_actualizacion_estacion() {
  local raiz=$1 fase fallo=false
  for fase in actualizar_checkout_dotfiles actualizar_configuraciones_dotbot actualizar_dnf actualizar_homebrew actualizar_flatpak actualizar_appimages actualizar_extensiones_gnome; do
    case $fase in
      actualizar_checkout_dotfiles|actualizar_configuraciones_dotbot|actualizar_extensiones_gnome|actualizar_appimages) "$fase" "$raiz" || fallo=true ;;
      *) "$fase" || fallo=true ;;
    esac
  done
  mostrar_resumen_final
  [[ $fallo == false && ${#RESULTADOS_FALLIDOS[@]} -eq 0 ]]
}
