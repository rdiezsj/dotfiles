# Tasks

## 1. Catálogo Homebrew de Firefox PWA

- [x] 1.1 Declarar `firefoxpwa` en `catalogs/homebrew.sh` y retirarlo de los catálogos DNF/RPM; verificar sintaxis y ausencia de duplicados.
- [x] 1.2 Eliminar la configuración de Packagecloud y la ruta de RPM directo del bootstrap, sin incluir operaciones sobre `/etc/yum.repos.d/`; verificar que la fase de fuentes externas no modifica repositorios locales de Firefox PWA.
- [x] 1.3 Implementar el ejecutor idempotente de fórmulas Homebrew para Firefox PWA; verificar mediante un doble de `brew` los estados instalado, presente, fórmula fallida y Homebrew ausente.
- [x] 1.4 Actualizar las pruebas unitarias de catálogos y fuentes externas para la fórmula Homebrew; ejecutar las pruebas afectadas sin red ni privilegios.

## 2. Integración y documentación

- [x] 2.1 Integrar Firefox PWA en la fase posterior a Homebrew con resultados instalados, presentes y fallidos; verificar que un fallo no impide el resto del catálogo.
- [x] 2.2 Actualizar `README.md` y `docs/catalogo-fedora.md` para documentar Homebrew como origen de Firefox PWA y su verificación posterior; comprobar que no mencionan RPM directo ni Packagecloud como fuentes activas.
- [x] 2.3 Ejecutar `./scripts/check.sh`, las pruebas unitarias, `git diff --check` y `openspec validate --strict`; documentar la validación manual de `brew list --versions firefoxpwa` en Fedora.
