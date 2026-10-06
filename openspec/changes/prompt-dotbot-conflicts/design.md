# Design

## Context

El flujo actual mueve algunos destinos Zsh automáticamente y aborta otros al
primer conflicto. Sheldon depende de que Dotbot haya enlazado su configuración,
pero su aviso no identifica qué paso falló.

## Goals / Non-Goals

**Goals:**

- Resolver conflictos por destino con una elección humana visible.
- Mantener el original por defecto y aplicar el enlace solo tras confirmación.
- Diagnosticar la ausencia de configuración y lockfiles Sheldon.

**Non-Goals:**

- Cambiar configuraciones sin confirmación ni versionar lockfiles locales.
- Ejecutar enlaces forzados globales de Dotbot.

## Decisions

El preflight reunirá todos los conflictos y mostrará por ruta el destino y el
origen versionado. Rechazar la confirmación conserva el original y detiene la
fase; aceptarla mueve el destino a una ruta fechada y permite a Dotbot aplicar
la configuración existente sin configuraciones temporales. Sheldon comunicará
si falta enlace, perfil o descarga.

## Risks / Trade-offs

- [Muchas preguntas] → mostrar un resumen previo y una confirmación por conflicto.
- [Sustitución accidental] → confirmación explícita y respaldo fechado.
- [Red no disponible] → preservar enlaces y señalar el perfil Sheldon fallido.

## Migration Plan

1. Extraer detección y resolución de conflictos con dobles de terminal.
2. Integrar elecciones antes de Dotbot y diagnósticos Sheldon.
3. Actualizar pruebas y guía Zsh.
