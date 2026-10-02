# Tasks

## 1. Núcleo, compatibilidad y validación

- [x] 1.1 Crear la estructura de núcleo y plataforma Fedora, y verificar que no contiene implementación de Ubuntu o macOS.
- [x] 1.2 Definir metadatos de compatibilidad por referencia y validar Fedora Workstation, versión y GNOME; verificar los casos compatible y no compatible sin modificar el equipo.
- [x] 1.3 Implementar el bootstrap público hacia `$HOME/.dotfiles` y la protección de líneas legacy; verificar en directorios temporales que una referencia incompatible no modifica el checkout.

## 2. Plan, interfaz y operaciones seguras

- [x] 2.1 Implementar simulación y plan previo con confirmación humana, y verificar que la simulación no ejecuta operaciones mutantes.
- [x] 2.2 Implementar salida Bash clara y activación progresiva de Gum, y verificar que el plan se entiende cuando Gum está ausente.
- [x] 2.3 Implementar resumen de instalados, presentes, omitidos, fallidos y acciones pendientes, y verificarlo con resultados simulados.

## 3. Dependencias y catálogos esenciales

- [x] 3.1 Implementar la comprobación e instalación idempotente de git, curl, zsh, flatpak, gum y Dotbot; verificar con dobles de comandos una primera y segunda ejecución.
- [x] 3.2 Crear catálogos Bash comentados en español para DNF/RPM, Flatpak, Homebrew y AppImage, y verificar su estructura declarativa.
- [x] 3.3 Implementar Homebrew y fuentes externas esenciales con verificación de origen, y comprobar que no se instalan aplicaciones, fuentes ni AppImages opcionales.

## 4. Scaffold, Nautilus y Dotbot mínimo

- [x] 4.1 Implementar el scaffold declarativo y las plantillas Nautilus de texto, Markdown y shell, y verificar sus rutas en un HOME temporal.
- [x] 4.2 Preparar Dotbot mínimo y la detección de rutas no gestionadas, y verificar que un conflicto detiene la operación sin reemplazar el destino.
- [x] 4.3 Implementar la reejecución idempotente del scaffold y de los enlaces gestionados, y verificar que una segunda ejecución no sobrescribe ni reinstala recursos conformes.

## 5. Vaultwarden y GNOME Keyring

- [x] 5.1 Implementar la fase final no bloqueante de Vaultwarden con solicitud de servidor y `--vault-server`, y verificar que cancelarla conserva el bootstrap base completado.
- [x] 5.2 Implementar el inicio de sesión `bw`, el almacenamiento exclusivo de sesión revocable en GNOME Keyring y su validación, y verificar que no se escriben contraseñas ni tokens en archivos o salidas.
- [x] 5.3 Documentar configuración y revocación de Vaultwarden, y verificar que la guía no contiene credenciales reales ni indica versionarlas.

## 6. Documentación e integración

- [x] 6.1 Documentar en README el comando de bootstrap, el plan, las confirmaciones y las referencias legacy, y verificar que los comandos documentados coinciden con pruebas.
- [x] 6.2 Mantener la estructura Markdown y la configuración de MkDocs Material, y verificar que la generación local de HTML finaliza correctamente.
- [x] 6.3 Añadir pruebas automatizadas para la lógica que no modifica un equipo real y una comprobación integral con secretos simulados, y verificar que la suite pasa.
