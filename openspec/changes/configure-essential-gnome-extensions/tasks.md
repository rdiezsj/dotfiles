# Tasks

## 1. Catálogo Fedora para extensiones

- [x] 1.1 Declarar AppIndicator, Dash to Dock, `libgtop2-devel` y `lm_sensors` en el catálogo DNF con sus finalidades; verificar su presencia, descripciones y ausencia de duplicados con `tests/unit/catalogos.sh`.
- [x] 1.2 Ampliar los dobles DNF de `tests/unit/catalogo-software.sh` para cubrir la instalación idempotente de los paquetes de extensiones; verificar que la prueba pasa.

## 2. Gestión de extensiones GNOME

- [x] 2.1 Crear el ejecutor aislado del bloque «Extensiones GNOME» con la tabla de nombre, UUID y origen de AppIndicator, Custom Hot Corners Extended, Clipboard Indicator, Vitals y Dash to Dock; verificar su sintaxis Bash.
- [x] 2.2 Implementar la obtención de archivos desde extensions.gnome.org para Custom Hot Corners Extended, Clipboard Indicator y Vitals, seleccionando una publicación compatible con la versión de GNOME Shell y sin usar Git, compilación ni COPR; verificar los casos compatible y no disponible con dobles de red y comandos.
- [x] 2.3 Ajustar la activación idempotente por UUID para comunicar como pendiente una extensión recién instalada que aún no puede activarse, con `activar-extensiones-gnome` como siguiente paso y sin añadir la extensión ni la fase a «Fallidos»; conservar los fallos de instalación o compatibilidad y verificar extensiones nuevas, presentes, inactivas, diferidas y fallidas con `tests/unit/extensiones-gnome.sh`.
- [x] 2.4 Añadir el ejecutable posterior de activación y verificación de las extensiones declaradas, sin reinstalar, actualizar ni modificar preferencias; verificar éxito, extensión ya activa y fallo persistente con una prueba unitaria dedicada.

## 3. Integración y documentación

- [x] 3.1 Integrar «Extensiones GNOME» como fase independiente tras el catálogo de software del bootstrap; verificar el orden con `tests/unit/bootstrap-simulacion.sh` o una prueba focalizada equivalente.
- [x] 3.2 Publicar el alias `activar-extensiones-gnome` en la configuración interactiva de Zsh y documentar el flujo posterior a una nueva sesión, sus fuentes, UUID, dependencias y estado local no versionado; verificar el alias con una prueba unitaria y la documentación con `tests/unit/documentacion.sh` y `mkdocs build --strict` cuando estén disponibles.
- [ ] 3.3 Ejecutar `bash tests/unit/run.sh`, `./scripts/check.sh`, `openspec validate configure-essential-gnome-extensions --strict` y `git diff --check`; verificar en una VM Fedora limpia que, tras una nueva sesión, `activar-extensiones-gnome` completa solo la activación declarada.
