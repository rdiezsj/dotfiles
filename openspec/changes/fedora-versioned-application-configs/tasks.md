# Tasks

## 1. Configuraciones fuente y plantillas seguras

- [ ] 1.1 Añadir `home/.nanorc`, `home/.vimrc`, `home/.gitconfig` y `home/.gitignore` con una configuración base válida y comentarios para tabulación pendiente; verificar la sintaxis de los formatos aplicables y que `.gitconfig` declara `~/.gitignore` como exclusión global.
- [ ] 1.2 Añadir las configuraciones portables de Terminator y Flameshot bajo `home/config/`, sin fijar una ruta personal de capturas; verificar que los archivos pueden ser leídos por sus aplicaciones o sus validadores disponibles.
- [ ] 1.3 Añadir exclusivamente `home/config/Heynote/config.json` y `home/config/Heynote/Preferences`; verificar que no se incorpora ningún otro archivo de Heynote ni contenido de notas, buffers o caché.
- [ ] 1.4 Añadir la configuración base de Input Remapper 2 con `autoload` vacío y la estructura para presets explícitos; verificar que el JSON es válido y que no contiene nombres de dispositivos ni asociaciones automáticas.
- [ ] 1.5 Añadir plantillas no activas para msmtp y Gear Lever, documentando los campos o preferencias pendientes; verificar mediante búsqueda que no contienen contraseñas, tokens, direcciones SMTP reales ni rutas del equipo.

## 2. Aplicación declarativa y catálogo Fedora

- [ ] 2.1 Declarar en `install.conf.yaml` los enlaces para las configuraciones activas de Nano, Vim, Git, Terminator, Flameshot, Heynote e Input Remapper 2; verificar que conserva la política de conflicto de Dotbot y no enlaza las plantillas no activas.
- [ ] 2.2 Extender el catálogo DNF con `nano`, `msmtp` y `flameshot`, incluyendo descripciones en español; verificar con la prueba unitaria de catálogo que una segunda ejecución los considera presentes.
- [ ] 2.3 Habilitar de forma idempotente el servicio de sistema de Input Remapper después de aplicar su configuración base; verificar con dobles unitarios los casos habilitado, habilitación correcta y fallo sin activar remapeos.
- [ ] 2.4 Actualizar el plan y resumen del bootstrap para informar de configuraciones aplicadas, plantillas pendientes y fallos por conflicto; verificar esos resultados mediante pruebas de simulación.

## 3. Pruebas y documentación de operación

- [ ] 3.1 Ampliar las pruebas unitarias de Dotbot y configuraciones para comprobar rutas exactas, enlaces gestionados, destinos no gestionados y exclusión de datos sensibles; verificar con `bash tests/unit/run.sh`.
- [ ] 3.2 Documentar en `README.md` y `docs/catalogo-fedora.md` las rutas versionadas, las plantillas pendientes y el procedimiento posterior para completar msmtp, tabulación, Flameshot, Gear Lever e Input Remapper; verificar que los comandos y rutas documentados coinciden con el repositorio.
- [ ] 3.3 Ejecutar `./scripts/check.sh`, `git diff --check` y `openspec validate --strict --change fedora-versioned-application-configs`; registrar cualquier validación que requiera una VM Fedora real como comprobación manual pendiente.
