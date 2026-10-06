# Spec Delta

## MODIFIED Requirements

### Requirement: Sitio estático desde Markdown
El sistema SHALL mantener Markdown como fuente de documentación y SHALL generar
un sitio HTML con MkDocs Material para GitHub Pages. SHALL publicar el sitio
mediante un flujo de GitHub Actions al cambiar la documentación o su
configuración. SHALL ofrecer una navegación orientada a tareas que separe
inicio, instalación, catálogo de software, configuración, shell y seguridad.

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

#### Scenario: Recorrido de una instalación nueva
- **WHEN** una persona abre la página de inicio
- **THEN** encuentra requisitos, instalación rápida, simulación, verificaciones
  posteriores y enlaces a las guías que necesita

## ADDED Requirements

### Requirement: Catálogo de aplicaciones trazable
La documentación SHALL agrupar las aplicaciones por tipo de paquetería y SHALL
indicar para cada una su finalidad, su gestor, si tiene configuración
versionada y qué configuración, datos o estado se mantienen exclusivamente en
el equipo.

#### Scenario: Consulta de una aplicación instalada
- **WHEN** una persona consulta una aplicación del catálogo
- **THEN** puede determinar su finalidad, origen y tratamiento de configuración
  sin inspeccionar los scripts de instalación
