# Design

## Context

La primera iteración implementa el punto de entrada mínimo del repositorio. Debe preparar una Fedora Workstation con GNOME sin activar todavía la configuración amplia de la estación, pero incluyendo las dependencias esenciales de Homebrew, fuentes externas y Vaultwarden. Véanse las especificaciones para el contrato observable.

## Goals / Non-Goals

**Goals:**

- Validar Fedora Workstation con GNOME y explicar el plan antes de cambiar el equipo.
- Instalar dependencias mínimas, Homebrew, fuentes externas esenciales, scaffold, plantillas y Dotbot mínimo.
- Mantener una fase Vaultwarden no bloqueante y persistir solo su sesión revocable.
- Detectar conflictos antes de sobrescribir rutas personales y resumir el resultado de cada ejecución.

**Non-Goals:**

- Instalar el catálogo completo de aplicaciones, fuentes tipográficas o AppImages.
- Configurar GNOME, extensiones, atajos, Zsh avanzado, starship, plugins, servicios o sincronización de secretos.
- Implementar Ubuntu, macOS o migraciones entre versiones mayores de Fedora.

## Decisions

### Flujo de bootstrap con plan previo

`./bootstrap` validará la plataforma, resolverá dependencias y rutas objetivo y presentará un plan. La simulación no ejecutará operaciones mutantes; el modo de aplicación solicitará confirmación antes de cada fase que pueda modificar el sistema. Gum se usará desde el momento en que exista; antes, la misma información se muestra con Bash.

Alternativa descartada: aplicar cambios en cuanto se detectan. Reduce preguntas, pero impide revisar conflictos y contradice el requisito de no sobrescribir configuraciones personales.

### Conflictos de Dotbot

Dotbot solo se preparará en esta iteración. Ante un destino no gestionado, el proceso se detendrá sin reemplazarlo y pedirá una confirmación humana explícita. No se harán copias ni reemplazos automáticos; la política de copia recuperable queda para una iteración posterior.

### Dependencias y catálogos

DNF instalará solo las dependencias mínimas y el grupo `development-tools` requerido por Homebrew. Homebrew y las fuentes externas esenciales se prepararán mediante declaraciones verificables. Tras instalar Homebrew, el bootstrap activará su entorno en el proceso actual y añadirá bloques identificables e idempotentes a `.bashrc` y `.zshrc`, sin cambiar todavía la shell predeterminada con `chsh`. Los catálogos Bash separados estarán presentes, pero no instalarán el catálogo completo, fuentes ni AppImages opcionales.

### Secretos y documentación

Vaultwarden se configura al final sin bloquear el resultado base, pero Bitwarden CLI se instala antes de solicitar la URL del servidor. `bw` recibe la contraseña maestra de su interfaz y GNOME Keyring conserva únicamente una sesión revocable. El resumen solo mostrará pendientes reales. El README documenta el bootstrap y la documentación de mayor alcance continuará publicándose con MkDocs Material.

## Risks / Trade-offs

- [La detección de GNOME depende de la sesión disponible] → Explicar el requisito y no aplicar cambios si no puede verificarse.
- [Las fuentes externas pueden cambiar] → Declarar origen y verificación, y fallar sin instalar sus dependencias si no coinciden.
- [Un conflicto de Dotbot necesita intervención] → Detener la fase afectada y describir la ruta y la acción necesaria.
- [Vaultwarden puede no estar disponible] → Finalizar el bootstrap base y marcar la configuración de secretos como pendiente.

## Migration Plan

1. Ejecutar simulación en Fedora Workstation con GNOME y revisar el plan.
2. Confirmar el bootstrap en un HOME de prueba y comprobar scaffold, plantillas, dependencias y resumen.
3. Ejecutar una segunda vez y comprobar que no se producen cambios innecesarios.
4. Probar rutas no gestionadas y comprobar que se detienen sin reemplazo.
