#!/usr/bin/env bash

# Firefox PWA se distribuye como RPM oficial fijado a una release de GitHub.
# La actualización exige revisar y versionar una nueva versión y su SHA-256.
FIREFOXPWA_VERSION='2.20.0-1'
FIREFOXPWA_ARQUITECTURA='x86_64'
FIREFOXPWA_NOMBRE="firefoxpwa-${FIREFOXPWA_VERSION}.${FIREFOXPWA_ARQUITECTURA}.rpm"
FIREFOXPWA_URL="https://github.com/filips123/PWAsForFirefox/releases/download/v2.20.0/${FIREFOXPWA_NOMBRE}"
FIREFOXPWA_SHA256='32396639489a438d6a3970128a54ab2c09b720cc0adc286f18d91bee4be8e965'

firefoxpwa_declaracion_valida() {
  [[ $FIREFOXPWA_ARQUITECTURA == x86_64 ]] || return 1
  [[ $FIREFOXPWA_NOMBRE == "firefoxpwa-${FIREFOXPWA_VERSION}.${FIREFOXPWA_ARQUITECTURA}.rpm" ]] || return 1
  [[ $FIREFOXPWA_URL == "https://github.com/filips123/PWAsForFirefox/releases/download/v${FIREFOXPWA_VERSION%-*}/${FIREFOXPWA_NOMBRE}" ]] || return 1
  [[ $FIREFOXPWA_SHA256 =~ ^[[:xdigit:]]{64}$ ]]
}
