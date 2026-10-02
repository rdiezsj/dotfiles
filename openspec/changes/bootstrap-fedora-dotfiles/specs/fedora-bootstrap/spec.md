# Spec Delta

## Purpose

Permite iniciar de forma segura un bootstrap reproducible en un equipo Fedora Workstation con una sesión GNOME compatible.

## ADDED Requirements

### Requirement: Validación de entorno Fedora Workstation GNOME
El sistema SHALL verificar que el equipo ejecuta Fedora Workstation, una versión mayor compatible y una sesión GNOME antes de proponer cambios.

#### Scenario: Entorno compatible
- **WHEN** se ejecuta `./bootstrap` en Fedora Workstation con GNOME compatible
- **THEN** el sistema muestra una única confirmación de compatibilidad y el plan de bootstrap

#### Scenario: Entorno no compatible
- **WHEN** el sistema no es Fedora Workstation, no usa GNOME o declara una versión incompatible
- **THEN** el bootstrap termina sin modificar el equipo y explica la condición no satisfecha

### Requirement: Bootstrap público versionado
El sistema SHALL ofrecer un comando documentado que clone la referencia solicitada en `$HOME/.dotfiles` y continúe la instalación desde ese checkout.

#### Scenario: Instalación inicial desde main compatible
- **WHEN** una persona ejecuta el comando documentado en una Fedora compatible con `main`
- **THEN** el bootstrap crea o reutiliza el checkout en `$HOME/.dotfiles` y ejecuta la instalación de esa referencia

### Requirement: Compatibilidad estricta de Fedora
El bootstrap SHALL comprobar la compatibilidad declarada de la referencia antes de cambiar el checkout o aplicar configuración.

#### Scenario: Main incompatible con el equipo
- **WHEN** un equipo Fedora 44 solicita `main` que declara compatibilidad con Fedora 45
- **THEN** la operación termina sin actualizar el checkout ni aplicar configuración y comunica la referencia Fedora 44 disponible

### Requirement: Líneas legacy inmutables
El sistema SHALL publicar una etiqueta inmutable al retirar una versión de Fedora de `main` y SHALL tratarla como histórica sin mantenimiento ordinario.

#### Scenario: Ejecución de una línea legacy explícita
- **WHEN** una persona solicita la etiqueta histórica compatible con su Fedora
- **THEN** el bootstrap permite la ejecución sin sustituirla por `main`
