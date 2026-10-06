# Design

## Context

El contenido público está en seis páginas Markdown bajo `docs/`, con navegación definida en `mkdocs.yml`. `.github/workflows/documentation.yml` construye y despliega el sitio de Pages; el trabajo de Wiki no debe alterar ni bloquear ese despliegue. La Wiki de GitHub se gestiona como un repositorio Git independiente. Véase `proposal.md` para la motivación y la especificación para el contrato observable.

## Goals / Non-Goals

**Goals:**

- Sincronizar a la Wiki las páginas públicas incluidas en la navegación MkDocs, sin duplicar su contenido fuente.
- Generar una portada `Home.md`, una barra `_Sidebar.md` y enlaces válidos para el formato Wiki.
- Mantener la publicación de Wiki aislada del despliegue de Pages y proteger la credencial requerida.

**Non-Goals:**

- Convertir la Wiki en fuente canónica, reemplazar MkDocs/Pages o editar páginas manualmente dentro del repositorio Wiki.
- Integrar el repositorio Wiki como submódulo. Esa alternativa queda expresamente aplazada para una exploración futura independiente.
- Configurar ahora los ajustes o secretos del repositorio; se verifican y, si hace falta, los configura una persona antes de activar el job.

## Decisions

1. **`docs/` sigue siendo la única fuente.** El job exporta las páginas Markdown listadas por `mkdocs.yml` a un directorio temporal. Esto evita mantener dos copias editables; las alternativas de redactar directamente en Wiki o convertir el HTML final de MkDocs duplicarían contenido o perderían la edición Markdown nativa de Wiki.

2. **Adaptar la navegación durante la exportación.** La portada del sitio se materializa como `Home.md`, la navegación MkDocs como `_Sidebar.md` y los enlaces relativos `.md` se transforman a referencias Wiki. Se copian los recursos locales que referencien las páginas si los hay. La exportación verifica que cada destino exista antes de publicar.

3. **Sincronizar con un job separado en el flujo de documentación.** El job de Wiki se ejecuta ante cambios de documentación en `main`, publica al repositorio Wiki en su rama predeterminada y no es dependencia del job de despliegue Pages. Así, un problema de permisos o de Wiki no impide actualizar Pages.

4. **Precondiciones operativas antes de activar la publicación.** Confirmar que la Wiki está habilitada y seleccionar una credencial de Actions protegida con permiso de escritura solo donde sea necesario. No fijar el valor en YAML, no imprimirlo ni conservarlo en el remoto local tras el push. Si la precondición no se cumple, dejar la publicación desactivada y documentar el ajuste pendiente.

5. **No versionar el repositorio Wiki como submódulo.** La publicación automatizada solo necesita escribir la copia generada. Incorporar un submódulo añade otra relación de checkout/actualización y no es necesario para sincronizar; no se investigará ni decidirá esa opción en este cambio.

## Risks / Trade-offs

- **El formato Markdown de Wiki no es idéntico a la navegación de MkDocs** → probar la conversión de nombres, portada, sidebar y enlaces con todas las páginas actuales.
- **Permisos de escritura mal configurados pueden exponer una credencial o romper la sincronización** → requerir Actions Secrets/credencial protegida, mínimo acceso, no imprimir comandos autenticados y mantener el job aislado de Pages.
- **La Wiki puede no estar habilitada en el repositorio** → comprobarlo antes de activar el job; no crear una publicación alternativa ni cambiar ajustes silenciosamente.
- **Ediciones manuales de Wiki podrían ser sobrescritas** → indicar que `docs/` es la fuente y que los cambios se hacen en el repositorio principal.

## Migration Plan

1. Confirmar disponibilidad de Wiki y el método de autenticación autorizado; no avanzar con el job activo mientras falte alguno.
2. Implementar y probar la exportación Markdown y la validación local de enlaces.
3. Activar el job separado y verificar una publicación en la Wiki, junto con un despliegue Pages independiente.
4. Para rollback, desactivar el job de sincronización; conservar Pages y la Wiki existente sin borrado automático.
