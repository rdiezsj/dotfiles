# Tasks

## 1. Declaraciones y fuentes del catálogo

- [ ] 1.1 Definir descriptores en español para los paquetes DNF, IDs Flatpak y AppImage acordados, incluidas versión, URL y SHA-256 de los AppImage; verificar sintaxis y que no hay identificadores duplicados.
- [ ] 1.2 Implementar la validación y configuración idempotente del repositorio RPM oficial de Microsoft y de las fuentes RPM Fusion necesarias; verificar con dobles que una URL o clave no declarada detiene la fase.
- [ ] 1.3 Documentar los orígenes, las exclusiones de Homebrew/Zsh y la política de configuración versionable; verificar enlaces y comandos documentados.

## 2. Ejecución y reconciliación de software base

- [ ] 2.1 Implementar ejecutores idempotentes para DNF y Flatpak, con resultados por elemento; verificar primera y segunda ejecución mediante dobles de los gestores.
- [ ] 2.2 Implementar los grupos exclusivos Firefox y ONLYOFFICE, con detección y retirada visible de variantes Snap, Flatpak, LibreOffice y FreeOffice; verificar que no se eliminan elementos no declarados.
- [ ] 2.3 Implementar descarga temporal, verificación SHA-256 y colocación no destructiva de Heynote y Nextcloud AppImage en `~/Apps`; verificar las rutas conforme, existente y checksum incorrecto.
- [ ] 2.4 Instalar y habilitar Syncthing como unidad `systemd --user`; verificar con un doble de `systemctl --user` que no se invoca como root.

## 3. Multimedia y NVIDIA

- [ ] 3.1 Implementar la sustitución idempotente a FFmpeg completo, grupo multimedia, códecs y soporte DVD de RPM Fusion; verificar que falla de forma explícita si la fuente DVD no se puede validar.
- [ ] 3.2 Implementar detección PCI de NVIDIA, instalación condicionada de akmods, CUDA y bibliotecas VA-API de 64/32 bits; verificar escenarios RTX 4060 Ti y equipo sin NVIDIA con dobles.
- [ ] 3.3 Detectar Secure Boot, comprobar el estado posterior de akmods y comunicar reinicio o enrolamiento MOK pendiente; verificar que no se declara operativo un controlador no validado.
- [ ] 3.4 Documentar la verificación posterior al reinicio de multimedia, NVIDIA y Secure Boot; verificar que no contiene claves, contraseñas ni instrucciones para desactivar Secure Boot.

## 4. Integración del bootstrap

- [ ] 4.1 Integrar las fases aprobadas en el plan, simulación y resumen del bootstrap sin ejecutar fórmulas Homebrew/Zsh; verificar la simulación y una reejecución íntegra con dobles.
- [ ] 4.2 Ejecutar la suite de pruebas, `openspec validate --strict`, `git diff --check` y una prueba funcional en Fedora con y sin GPU NVIDIA cuando esté disponible; documentar cualquier verificación dependiente de hardware real.
