# Tasks

## 1. Configuración global de Codex

- [x] 1.1 Copiar `~/.codex/AGENTS.md` y todo `~/.codex/skills/` a `home/.codex/`, incluidos `.system/` y recursos ocultos; verificar rutas, contenido y ausencia de secretos.
- [x] 1.2 Añadir enlaces Dotbot para `~/.codex/AGENTS.md` y `~/.codex/skills`; extender la gestión de conflictos para respaldar directorios solo tras confirmación y verificar casos de aceptación, rechazo y enlaces conformes con pruebas unitarias.
- [x] 1.3 Documentar qué configuración Codex se versiona y qué estado queda fuera; verificar que la guía coincide con los destinos de Dotbot.

## 2. ChatGPT de escritorio en Fedora

- [x] 2.1 Declarar las URLs RPM oficiales por arquitectura e instalar ChatGPT de forma idempotente solo en versiones Fedora y arquitecturas compatibles; verificar estados presente, ausente, fallo y plataforma no compatible con pruebas aisladas.
- [x] 2.2 Documentar la instalación de ChatGPT y su repositorio oficial de actualización; verificar el comando de apertura y las plataformas admitidas contra la documentación oficial.

## 3. OpenSpec como CLI global

- [x] 3.1 Añadir la fórmula `openspec` al catálogo Homebrew y reconocer antes una CLI global funcional; verificar instalación ausente, estado presente y ausencia de duplicados con stubs.
- [x] 3.2 Documentar que OpenSpec queda global y no como dependencia por proyecto; verificar que la documentación identifica Homebrew y el comando de comprobación.

## 4. Integración

- [x] 4.1 Ejecutar las pruebas unitarias relevantes y `./scripts/check.sh`; verificar además `openspec validate --strict --all` y una simulación del catálogo sin instalar paquetes en el equipo de desarrollo.
