# Tasks

## 1. Catálogo y fuente verificable de Firefox PWA

- [x] 1.1 Declarar en un catálogo separado la versión, URL oficial x86_64, nombre y SHA-256 de Firefox PWA; verificar que la URL y la suma tienen el formato esperado y que `firefoxpwa` deja de pertenecer al catálogo DNF ordinario.
- [x] 1.2 Eliminar la configuración de Packagecloud del bootstrap y retirar su plantilla del repositorio sin incluir operaciones sobre `/etc/yum.repos.d/`; verificar que la fase de fuentes externas no intenta modificar repositorios locales de Firefox PWA.
- [x] 1.3 Implementar la descarga temporal, validación SHA-256 e instalación idempotente del RPM local mediante DNF; verificar mediante dobles los estados instalado, presente, descarga fallida, suma inválida y fallo de DNF.
- [x] 1.4 Actualizar las pruebas unitarias de catálogos y fuentes externas para la nueva release declarada; ejecutar las pruebas afectadas sin red ni privilegios.

## 2. Integración y documentación

- [x] 2.1 Integrar Firefox PWA en la fase del catálogo con resultados instalados, presentes, omitidos y fallidos; verificar que un fallo no impide el resto del catálogo.
- [x] 2.2 Actualizar `README.md` y `docs/catalogo-fedora.md` para documentar el origen de GitHub Releases, la suma verificada y la actualización al modificar el catálogo; verificar que no mencionan Packagecloud como fuente activa.
- [x] 2.3 Ejecutar `./scripts/check.sh`, las pruebas unitarias, `git diff --check` y `openspec validate --strict`; documentar la instalación manual de validación en Fedora x86_64.
