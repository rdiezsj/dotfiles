# Tasks

## 1. Preferencia portable de Gear Lever

- [x] 1.1 Añadir una declaración versionada y un helper mínimo para aplicar, dentro del Flatpak de Gear Lever, la clave `appimages-default-folder` resuelta como `$HOME/Apps`; verificar con un doble de Flatpak/GSettings que la clave y la ruta exactas se envían tras instalar Gear Lever.
- [x] 1.2 Integrar el helper en la fase posterior al catálogo Flatpak, manteniendo visible el fallo si Gear Lever o su esquema no están disponibles; verificar la primera ejecución, la repetición idempotente y el caso de fallo con pruebas unitarias.
- [x] 1.3 Actualizar la prueba de configuraciones para permitir solo la declaración de Gear Lever y seguir rechazando sandbox, inventario, rutas por aplicación, actualizaciones, cachés y credenciales; verificarla junto con el resto de configuraciones versionadas.
- [x] 1.4 Actualizar `docs/instalacion.md` y `docs/catalogo-fedora.md` para documentar `~/Apps` como ruta predeterminada de Gear Lever y los límites de estado local; verificar que la documentación coincide con la declaración y el catálogo.

## 2. Compatibilidad FUSE para AppImage v2

- [x] 2.1 Confirmar en los repositorios de Fedora el paquete que aporta `libfuse.so.2` para la arquitectura objetivo y declararlo con su descripción en el catálogo DNF; verificar el proveedor y que no se introduce una fuente externa.
- [x] 2.2 Reutilizar el ejecutor DNF idempotente para instalar la compatibilidad FUSE durante el catálogo y registrarla como instalada o presente; verificar ambos resultados con dobles en `tests/unit/catalogo-software.sh`.
- [x] 2.3 Añadir una comprobación de la biblioteca FUSE de compatibilidad y un resultado de fallo accionable si no está disponible tras la instalación; verificar los casos de biblioteca disponible y ausente sin ejecutar un AppImage real.
- [x] 2.4 Documentar la dependencia FUSE de AppImage v2 y el comportamiento de recuperación si el catálogo no puede instalarla; verificar que no se propone `--appimage-extract-and-run` como sustituto del bootstrap.

## 3. Configuraciones de aplicación personalizadas

- [x] 3.1 Versionar sin normalizar los ficheros manuales `config.json` y `Preferences` de Heynote y `flameshot.ini`; verificar su sintaxis JSON/INI y que Dotbot conserva sus destinos no gestionados.
- [x] 3.2 Sustituir el enlace individual de Input Remapper 2 por el enlace de su directorio completo, incluidos los presets; verificar mediante una HOME temporal que `config.json` y el preset quedan enlazados.
- [x] 3.3 Actualizar la documentación y pruebas de configuración para reflejar las preferencias concretas de Flameshot y el directorio completo de Input Remapper 2; verificar que no se incorporan ficheros vecinos no declarados.

## 4. Verificación integrada

- [x] 4.1 Ejecutar las pruebas unitarias afectadas y `./scripts/check.sh`; verificar que las nuevas rutas, la configuración de Gear Lever y FUSE pasan, registrando cualquier limitación externa preexistente.
- [x] 4.2 Ejecutar `openspec validate configure-gearlever-appimages --strict` y verificar que las especificaciones, diseño y tareas del cambio son válidos.
