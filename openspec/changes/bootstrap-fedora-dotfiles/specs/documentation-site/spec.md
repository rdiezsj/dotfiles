# Spec Delta

## Purpose

Publica documentación operativa mantenible a partir de Markdown para que la instalación y el uso del repositorio sean accesibles y verificables.

## ADDED Requirements

### Requirement: Instrucción de instalación pública
El README SHALL documentar el comando de bootstrap público, su referencia por defecto, las referencias legacy y el comportamiento ante incompatibilidad de Fedora.

#### Scenario: Consulta de instalación legacy
- **WHEN** una persona consulta la documentación desde una Fedora legacy
- **THEN** encuentra el comando que selecciona su etiqueta compatible y la explicación de por qué `main` se rechaza

### Requirement: Sitio estático desde Markdown
El sistema SHALL mantener Markdown como fuente de documentación y SHALL generar un sitio HTML con MkDocs Material para GitHub Pages.

#### Scenario: Publicación de documentación
- **WHEN** se ejecuta el flujo de publicación con documentación válida
- **THEN** se genera y publica el sitio HTML sin requerir editar HTML manualmente

### Requirement: Documentación de seguridad operativa
La documentación SHALL explicar que el repositorio público no contiene secretos y que Vaultwarden y GNOME Keyring se usan sin publicar contraseñas ni sesiones.

#### Scenario: Consulta de la integración de secretos
- **WHEN** una persona consulta la guía de Vaultwarden
- **THEN** encuentra los pasos de configuración y las garantías de que no se versionan credenciales
