#!/usr/bin/env bash

# AppImage fijados a una versión concreta. Las sumas se verificaron contra los
# binarios oficiales antes de declararlos; nunca se resuelven dinámicamente.
PAQUETES_APPIMAGE=(heynote nextcloud)

declare -gA APPIMAGE_NOMBRE=(
  [heynote]='Heynote_2.9.1_x86_64.AppImage'
  [nextcloud]='Nextcloud-34.0.4-x86_64.AppImage'
)
declare -gA APPIMAGE_VERSION=(
  [heynote]='2.9.1'
  [nextcloud]='34.0.4'
)
declare -gA APPIMAGE_URL=(
  [heynote]='https://github.com/heyman/heynote/releases/download/v2.9.1/Heynote_2.9.1_x86_64.AppImage'
  [nextcloud]='https://download.nextcloud.com/desktop/releases/Linux/Nextcloud-34.0.4-x86_64.AppImage'
)
declare -gA APPIMAGE_SHA256=(
  [heynote]='dfb6acdbd261e57cf79c45b96abc83e76a6ea9a0a203194c06cf9a44865b6d4f'
  [nextcloud]='7ee587625ec9db0d3923a867a3075c08904d25f442a88d56068d0f1728eeb47c'
)

# Solo Heynote publica en su API oficial de GitHub la suma SHA-256 del binario.
# Nextcloud ofrece una firma separada, que requiere declarar su clave antes de
# poder automatizar su sustitución con el mismo nivel de verificación.
declare -gA APPIMAGE_MANIFIESTO_GITHUB=(
  [heynote]='https://api.github.com/repos/heyman/heynote/releases/latest'
)
