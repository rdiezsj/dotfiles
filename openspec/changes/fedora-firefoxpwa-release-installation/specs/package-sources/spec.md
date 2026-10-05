# Spec Delta

## ADDED Requirements

### Requirement: Fórmula Homebrew de Firefox PWA
El sistema SHALL declarar `firefoxpwa` en el catálogo Homebrew y comprobar mediante Homebrew si la fórmula está instalada antes de instalarla.

#### Scenario: Fórmula declarada
- **WHEN** se inspecciona el catálogo Homebrew
- **THEN** incluye `firefoxpwa` como fórmula gestionada para Fedora

#### Scenario: Homebrew no disponible
- **WHEN** Homebrew no queda disponible tras su fase de instalación
- **THEN** Firefox PWA queda registrado como fallido sin detener el resto del catálogo
