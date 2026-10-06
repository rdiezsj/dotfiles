# Proposal

## Why

La documentación pública ya se mantiene en Markdown y se publica como sitio MkDocs en GitHub Pages. También queremos ofrecerla en la Wiki del proyecto sin crear una segunda fuente que pueda quedar desactualizada.

## What Changes

- Publicar en la Wiki una copia navegable de las guías Markdown mantenidas en `docs/`, conservando MkDocs y GitHub Pages como publicación existente.
- Automatizar la sincronización al actualizar la documentación en `main`, con enlaces y navegación adaptados al formato Wiki.
- Comprobar antes de activar la publicación que la Wiki está habilitada y que el flujo dispone de permisos de escritura adecuados; no guardar credenciales en el repositorio.
- Mantener fuera de alcance decidir si el repositorio Wiki se integra como submódulo. Esa alternativa se explorará mucho más adelante y no condiciona esta propuesta.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `documentation-site`: añadir GitHub Wiki como destino complementario, manteniendo Markdown como fuente canónica y Pages como publicación vigente.

## Impact

- Flujo `.github/workflows/documentation.yml`, navegación de MkDocs y pruebas de documentación.
- Wiki GitHub del repositorio, su configuración de acceso y el mecanismo de autenticación del flujo, que deberán verificarse antes de aplicar.
- No cambia el bootstrap Fedora ni se introduce un submódulo.
