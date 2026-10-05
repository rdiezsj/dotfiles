# Proposal

## Why

El repositorio Packagecloud declarado para Firefox PWA no publica el paquete RPM, por lo que el catálogo termina con `firefoxpwa` fallido. La release oficial de PWAsForFirefox sí publica un RPM para Fedora x86_64, que permite mantener una instalación reproducible y verificable.

## What Changes

- Sustituir el repositorio RPM vacío de Packagecloud por la descarga directa de un RPM oficial de GitHub Releases.
- Declarar versión, URL y SHA-256 del RPM de Firefox PWA y comprobar la suma antes de instalarlo mediante DNF.
- Hacer la instalación idempotente: informar como presente cuando la versión declarada ya esté instalada y actualizarla solo al modificar el catálogo versionado.
- Dejar de declarar Packagecloud en nuevas instalaciones y adaptar la documentación y las pruebas unitarias, sin modificar repositorios locales existentes.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `fedora-software-catalog`: Firefox PWA pasa de ser un paquete resuelto desde un repositorio DNF a un RPM oficial de release descargado y verificado.
- `package-sources`: la fuente externa de Firefox PWA se declara como un artefacto de release con suma SHA-256, sin configurar Packagecloud.

## Impact

- Afecta `catalogs/dnf-rpm.sh`, `platforms/fedora/fuentes-externas.sh`, `platforms/fedora/catalogo-software.sh`, sus pruebas unitarias y la documentación del catálogo.
- Deja sin uso la plantilla `platforms/fedora/repos/firefoxpwa.repo`, que podrá retirarse del repositorio sin ejecutar ninguna operación sobre los repositorios locales; no introduce secretos ni cachés versionados.
