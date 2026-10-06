# Tasks

## 1. Configuraciones fuente y plantillas seguras

- [x] 1.1 Añadir `home/.nanorc`, `home/.vimrc`, `home/.gitconfig` y `home/.gitignore` con una configuración base válida y comentarios para tabulación pendiente; verificar la sintaxis de los formatos aplicables y que `.gitconfig` declara `~/.gitignore` como exclusión global.
- [x] 1.2 Añadir las configuraciones portables de Terminator y Flameshot bajo `home/config/`, sin fijar una ruta personal de capturas; verificar que los archivos pueden ser leídos por sus aplicaciones o sus validadores disponibles.
- [x] 1.3 Añadir exclusivamente `home/config/Heynote/config.json` y `home/config/Heynote/Preferences`; verificar que no se incorpora ningún otro archivo de Heynote ni contenido de notas, buffers o caché.
- [x] 1.4 Añadir la configuración base de Input Remapper 2 con `autoload` vacío y la estructura para presets explícitos; verificar que el JSON es válido y que no contiene nombres de dispositivos ni asociaciones automáticas.
- [x] 1.5 Declarar la configuración activa IONOS de msmtp sin credenciales y excluir archivos, plantillas y enlaces de Gear Lever; verificar mediante búsqueda que no contienen contraseñas, tokens ni sesiones.
- [x] 1.6 Añadir helpers ejecutables para obtener usuario y contraseña del ítem `Mail.ionos.es` desde una sesión válida de GNOME Keyring; verificar los casos de sesión válida, bloqueada y salida sin secretos.

## 2. Aplicación declarativa y catálogo Fedora

- [x] 2.1 Declarar en `install.conf.yaml` los enlaces para las configuraciones activas de Nano, Vim, Git, Terminator, Flameshot, Heynote, Input Remapper 2 y msmtp; verificar que conserva la política de conflicto de Dotbot y no enlaza las plantillas no activas.
- [x] 2.2 Extender el catálogo DNF con `nano`, `msmtp` y `flameshot`, incluyendo descripciones en español; verificar con la prueba unitaria de catálogo que una segunda ejecución los considera presentes.
- [x] 2.3 Habilitar de forma idempotente el servicio de sistema de Input Remapper después de aplicar su configuración base; verificar con dobles unitarios los casos habilitado, habilitación correcta y fallo sin activar remapeos.
- [x] 2.4 Actualizar el plan y resumen del bootstrap para informar de configuraciones aplicadas, la cuenta SMTP configurada bajo demanda y fallos por conflicto; verificar esos resultados mediante pruebas de simulación.

## 3. Pruebas y documentación de operación

- [x] 3.1 Ampliar las pruebas unitarias de Dotbot y configuraciones para comprobar rutas exactas, enlaces gestionados, destinos no gestionados y exclusión de datos sensibles; verificar con `bash tests/unit/run.sh`.
- [x] 3.2 Documentar en `README.md` y `docs/catalogo-fedora.md` las rutas versionadas, la cuenta IONOS bajo demanda y el procedimiento posterior para completar msmtp, tabulación, Flameshot e Input Remapper; verificar que los comandos y rutas documentados coinciden con el repositorio.
- [x] 3.3 Ejecutar `./scripts/check.sh`, `git diff --check` y `openspec validate --strict --change fedora-versioned-application-configs`; registrar cualquier validación que requiera una VM Fedora real como comprobación manual pendiente.
