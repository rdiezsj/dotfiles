#!/usr/bin/env bash

# Catálogo Flatpak de aplicaciones de escritorio. Se instala por usuario desde
# Flathub para no alterar aplicaciones de otros perfiles locales.
PAQUETES_FLATPAK=(
  org.onlyoffice.desktopeditors
  com.bitwarden.desktop
  md.obsidian.Obsidian
  com.github.dail8859.NotepadNext
  org.telegram.desktop
  com.spotify.Client
  org.kde.ark
  org.gnome.meld
  com.valvesoftware.Steam
  com.tomjwatson.Emote
  it.mijorus.gearlever
  org.localsend.localsend_app
)

declare -A DESCRIPCIONES_FLATPAK=(
  [org.onlyoffice.desktopeditors]='Suite ofimática ONLYOFFICE'
  [com.bitwarden.desktop]='Aplicación de escritorio Bitwarden'
  [md.obsidian.Obsidian]='Gestor de conocimiento Obsidian'
  [com.github.dail8859.NotepadNext]='Editor de texto NotepadNext'
  [org.telegram.desktop]='Cliente de Telegram'
  [com.spotify.Client]='Cliente de Spotify'
  [org.kde.ark]='Gestor de archivos comprimidos Ark'
  [org.gnome.meld]='Comparador de archivos Meld'
  [com.valvesoftware.Steam]='Cliente de Steam'
  [com.tomjwatson.Emote]='Selector de emoji Emote'
  [it.mijorus.gearlever]='Gestor de AppImage Gear Lever'
  [org.localsend.localsend_app]='Transferencia local LocalSend'
)

# Variantes que se retiran exclusivamente para mantener Firefox y ONLYOFFICE.
FLATPAK_EXCLUIDOS=(
  org.mozilla.firefox
  org.libreoffice.LibreOffice
  org.softmaker.FreeOffice
)
