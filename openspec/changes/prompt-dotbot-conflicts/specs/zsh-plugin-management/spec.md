# Spec Delta

## ADDED Requirements

### Requirement: Diagnóstico accionable de Sheldon
El sistema SHALL diferenciar si Sheldon no se materializó porque falta su configuración enlazada, falta un lockfile local o falló la materialización de un perfil. El resumen y el aviso de Zsh SHALL indicar la causa y la acción de recuperación aplicable.

#### Scenario: Configuración Sheldon no enlazada
- **WHEN** existe Sheldon pero falta `plugins.toml`
- **THEN** el diagnóstico identifica el enlace pendiente y remite a resolver el conflicto de Dotbot antes de materializar perfiles

#### Scenario: Perfil Sheldon no materializado
- **WHEN** existe la configuración pero falta un lockfile de perfil
- **THEN** el diagnóstico identifica el perfil concreto y remite a ejecutar el bootstrap tras resolver conflictos
