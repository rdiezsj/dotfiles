# Spec Delta

## MODIFIED Requirements

### Requirement: Sitio estático desde Markdown
El sistema SHALL mantener Markdown como fuente de documentación y SHALL generar
un sitio HTML con MkDocs Material para GitHub Pages. SHALL publicar el sitio
mediante un flujo de GitHub Actions al cambiar la documentación o su
configuración, y SHALL incluir la guía del catálogo Fedora en la navegación.

#### Scenario: Publicación de documentación
- **WHEN** se ejecuta el flujo de publicación con documentación válida
- **THEN** se genera y publica el sitio HTML sin requerir editar HTML manualmente

#### Scenario: Cambio en la documentación principal
- **WHEN** se integra en `main` un cambio en `docs/`, `mkdocs.yml` o el flujo
  de publicación
- **THEN** GitHub Actions construye y despliega el sitio en GitHub Pages

#### Scenario: Navegación del catálogo Fedora
- **WHEN** una persona abre el sitio publicado
- **THEN** puede acceder a la guía del catálogo Fedora desde la navegación
