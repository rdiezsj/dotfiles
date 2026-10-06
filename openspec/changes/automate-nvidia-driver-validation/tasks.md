# Tasks

## 1. Detección y estado de la pila NVIDIA

- [x] 1.1 Definir en `platforms/fedora/multimedia-nvidia.sh` la GPU compatible y el conjunto propietario RPM Fusion esperado, y verificar con dobles de `lspci` y `rpm` los estados sin GPU, compatible e instalación incompleta.
- [x] 1.2 Implementar comprobaciones idempotentes de paquetes, módulo `nvidia` para el kernel activo y disponibilidad de `nvidia-smi`; verificar que una pila operativa no invoca DNF ni akmods.
- [x] 1.3 Reparar exclusivamente los componentes NVIDIA no conformes mediante RPM Fusion y ejecutar la compilación akmods con espera acotada; verificar con dobles los resultados correcto, agotado y fallido.

## 2. Validación y resumen del bootstrap

- [x] 2.1 Integrar la máquina de estados NVIDIA en `bootstrap` para registrar controlador verificado, fallo o la instrucción explícita de reiniciar y ejecutar manualmente `./bootstrap`, y verificar la salida final en las pruebas del bootstrap.
- [x] 2.2 Mantener el tratamiento de Secure Boot sin reinicio ni reejecución automáticos y validar que el escenario sin MOK no declara el driver operativo mediante las pruebas unitarias NVIDIA.
- [x] 2.3 Actualizar `docs/catalogo-fedora.md`, `docs/instalacion.md` y el README conservando los cambios locales existentes; verificar que ya no instruyen ejecutar `nvidia-smi` manualmente y que documentan el reinicio y la reejecución manual de `./bootstrap`.

## 3. Verificación integrada

- [x] 3.1 Ejecutar `bash tests/unit/multimedia-nvidia.sh` y `bash tests/unit/bootstrap-simulacion.sh`, y verificar que pasan sin red, DNF, sudo ni cambios en el equipo real.
- [x] 3.2 Ejecutar `openspec validate "automate-nvidia-driver-validation" --strict` y verificar que propuesta, deltas, diseño y tareas son coherentes y válidos.
