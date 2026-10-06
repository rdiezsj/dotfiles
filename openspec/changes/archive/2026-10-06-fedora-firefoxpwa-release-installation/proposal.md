# Proposal

## Why

El repositorio Packagecloud declarado para Firefox PWA no publica el paquete RPM y la descarga directa de la release no ha resultado operativa en Fedora. Homebrew publica la fórmula `firefoxpwa` con botella para Linux x86_64, por lo que ofrece una instalación integrada con una fuente ya esencial para el bootstrap.

## What Changes

- Sustituir el repositorio RPM vacío de Packagecloud por la fórmula `firefoxpwa` de Homebrew.
- Declarar Firefox PWA en el catálogo Homebrew e instalarlo de forma idempotente tras preparar Homebrew.
- Informar de los estados instalado, presente o fallido de la fórmula sin detener el resto del catálogo.
- Dejar de declarar Packagecloud en nuevas instalaciones y adaptar la documentación y las pruebas unitarias, sin modificar repositorios locales existentes.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `fedora-software-catalog`: Firefox PWA pasa de ser un paquete resuelto desde un repositorio DNF a una fórmula Homebrew idempotente.
- `package-sources`: Firefox PWA se declara en el catálogo Homebrew, sin configurar Packagecloud ni descargar RPMs directamente.

## Impact

- Afecta `catalogs/dnf-rpm.sh`, `catalogs/homebrew.sh`, `platforms/fedora/fuentes-externas.sh`, `platforms/fedora/catalogo-software.sh`, sus pruebas unitarias y la documentación del catálogo.
- Deja sin uso la plantilla `platforms/fedora/repos/firefoxpwa.repo`, que podrá retirarse del repositorio sin ejecutar ninguna operación sobre los repositorios locales; no introduce secretos ni cachés versionados.
