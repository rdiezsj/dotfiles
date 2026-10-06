# Tasks

## 1. Resolución interactiva de conflictos

- [x] 1.1 Inventariar todos los destinos Dotbot no gestionados antes de modificar el HOME y verificar con dobles que se muestran juntos.
- [x] 1.2 Mostrar destino y origen de cada conflicto, solicitar confirmación y respaldar solo los destinos aceptados; verificar que rechazar conserva el original.
- [x] 1.3 Integrar las confirmaciones con Dotbot sin `force`, `relink` ni configuraciones temporales, y verificar que cancelar detiene la fase.

## 2. Diagnóstico Sheldon y documentación

- [x] 2.1 Distinguir configuración Sheldon no enlazada, perfil no materializado y fallo de materialización en el resumen y Zsh; verificar cada mensaje con dobles.
- [x] 2.2 Actualizar la guía Zsh y el README con el flujo de resolución y verificar los comandos documentados.

## 3. Verificación

- [x] 3.1 Ejecutar las pruebas unitarias afectadas y `./scripts/check.sh`, verificando que no usan Fedora ni un HOME real.
- [x] 3.2 Ejecutar `openspec validate "prompt-dotbot-conflicts" --strict` y verificar que la planificación es válida.
