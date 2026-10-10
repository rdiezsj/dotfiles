# Spec Delta

## ADDED Requirements

### Requirement: Acceso unificado al mantenimiento
El sistema SHALL ofrecer `dotfiles update` como acceso al mismo mantenimiento que el alias `update`, conservando su entorno, comportamiento y código de salida sin requerir Python. SHALL mantener el alias existente. La ayuda SHALL devolver 0 sin iniciar mantenimiento y los argumentos no admitidos SHALL devolver 2 sin ejecutar operaciones.

#### Scenario: Actualización desde el comando dotfiles
- **WHEN** se ejecuta `dotfiles update`
- **THEN** invoca el mantenimiento existente y devuelve su código de salida

#### Scenario: Ayuda o argumentos no admitidos
- **WHEN** se solicita ayuda de update o se pasan argumentos no admitidos
- **THEN** muestra el uso sin realizar operaciones de mantenimiento
