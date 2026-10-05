# Spec Delta

## ADDED Requirements

### Requirement: Artefacto externo verificable de Firefox PWA
El sistema SHALL declarar la versión, URL oficial y SHA-256 de Firefox PWA como un artefacto externo versionado. SHALL descargarlo temporalmente y verificarlo antes de solicitar su instalación mediante DNF.

#### Scenario: Declaración válida de release
- **WHEN** la URL declarada pertenece a una release oficial y el archivo coincide con su SHA-256
- **THEN** el bootstrap permite instalar el RPM descargado

#### Scenario: Declaración de release no válida
- **WHEN** la URL no pertenece al origen oficial o el archivo no coincide con su SHA-256
- **THEN** el bootstrap no instala el RPM y comunica el fallo de verificación
