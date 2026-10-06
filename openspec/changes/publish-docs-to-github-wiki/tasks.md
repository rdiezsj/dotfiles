# Tasks

## 1. Precondiciones de GitHub Wiki

- [ ] 1.1 Verificar que la Wiki del repositorio está habilitada, revisar si ya contiene páginas con nombres en conflicto y confirmar el mecanismo de Actions con permiso mínimo; si hace falta activar Wiki o configurar credenciales, pedir esa intervención y no habilitar aún la publicación.

## 2. Exportación Markdown para Wiki

- [ ] 2.1 Implementar una exportación temporal de las páginas públicas enumeradas en `mkdocs.yml` a `Home.md`, páginas Wiki y `_Sidebar.md`, adaptando enlaces y recursos; verificar nombres y destinos contra las seis páginas actuales.
- [ ] 2.2 Añadir pruebas aisladas de exportación para portada, navegación, enlaces locales válidos, destino inexistente y repetición idempotente; verificar que no se modifica `docs/` ni el contenido del sitio Pages.

## 3. Publicación automática

- [ ] 3.1 Añadir un job de sincronización Wiki en `.github/workflows/documentation.yml`, separado del despliegue Pages y activado por cambios documentales en `main`; verificar con una ejecución controlada que un fallo de Wiki no cancela Pages.
- [ ] 3.2 Usar la credencial protegida acordada, sin imprimirla ni persistirla en la URL remota, y documentar en README que `docs/` es la fuente canónica y cómo se publica Wiki; verificar que no se añade ningún secreto al repositorio.

## 4. Integración

- [ ] 4.1 Ejecutar pruebas de exportación, `bash tests/unit/documentacion.sh`, `mkdocs build --strict`, `./scripts/check.sh` y `openspec validate --strict --all`; comprobar además manualmente portada, sidebar, enlaces y publicación Pages/Wiki independientes.
