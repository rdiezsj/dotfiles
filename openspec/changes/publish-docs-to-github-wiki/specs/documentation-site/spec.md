# Spec Delta

## ADDED Requirements

### Requirement: Publicación complementaria en GitHub Wiki
El sistema SHALL publicar en la Wiki una copia navegable de la documentación Markdown pública de `docs/`, manteniendo esa carpeta como fuente canónica y conservando GitHub Pages como destino existente.

#### Scenario: Sincronización de la documentación
- **WHEN** se publica en `main` un cambio que actualiza la documentación cubierta
- **THEN** la Wiki refleja las páginas de `docs/` con navegación y enlaces adaptados a sus URL

#### Scenario: La publicación Wiki no está disponible
- **WHEN** la Wiki no está habilitada o el flujo carece de permiso para actualizarla
- **THEN** el flujo informa del fallo de sincronización sin borrar la Wiki, exponer credenciales ni impedir que GitHub Pages publique el sitio

### Requirement: Credenciales de publicación Wiki protegidas
El sistema SHALL guardar las credenciales con permiso de escritura a la Wiki fuera del repositorio y SHALL usarlas solo durante la sincronización.

#### Scenario: Sincronización autenticada
- **WHEN** el flujo publica páginas en la Wiki
- **THEN** obtiene la credencial desde el almacén protegido de GitHub Actions y no la imprime ni la versiona
