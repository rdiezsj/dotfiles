# package-sources Specification

## Purpose

Prepara las fuentes de software y las dependencias mínimas que necesita el bootstrap de una estación Fedora.

## Requirements

### Requirement: Dependencias mínimas del bootstrap
El sistema SHALL comprobar e instalar `git`, `curl`, `zsh`, `flatpak`, `gum` y las herramientas necesarias para Dotbot, sin instalar el catálogo general de aplicaciones.

#### Scenario: Dependencia ausente
- **WHEN** una dependencia mínima no está instalada
- **THEN** el plan la identifica y, tras confirmación, el bootstrap intenta instalarla

### Requirement: Catálogos base separados
El sistema SHALL mantener catálogos Bash diferenciados para DNF/RPM, Flatpak, Homebrew y AppImage, con comentarios en español que describan la finalidad de cada bloque. SHALL ejecutar de forma idempotente los catálogos aprobados y SHALL declarar Sheldon como la única dependencia Homebrew de gestión de plugins Zsh; las fórmulas de plugins Zsh no se duplicarán en el catálogo Homebrew.

#### Scenario: Revisión de catálogos
- **WHEN** se inspecciona la configuración de catálogos
- **THEN** cada tecnología dispone de un bloque separado y comentado en español

#### Scenario: Ejecución idempotente
- **WHEN** se confirma el bootstrap varias veces
- **THEN** Homebrew, Sheldon y los plugins ya satisfechos no se reinstalan ni sobrescriben configuraciones gestionadas

#### Scenario: Ejecución del catálogo aprobado
- **WHEN** se confirma el bootstrap con un catálogo DNF, Flatpak, Homebrew o AppImage aprobado
- **THEN** instala únicamente los elementos declarados por ese gestor

### Requirement: Homebrew y fuentes externas esenciales
El sistema SHALL instalar Homebrew, su grupo `development-tools` requerido en Fedora y configurar las fuentes externas declaradas necesarias para el bootstrap, incluyendo Sheldon, verificando su origen. Tras la instalación SHALL activar Homebrew en la sesión actual y mantener bloques idempotentes para Bash y Zsh sin reemplazar el contenido ajeno de sus archivos de inicio. SHALL configurar además el repositorio oficial de Microsoft para VS Code y las fuentes RPM Fusion necesarias para multimedia, DVD y NVIDIA solo tras validar sus orígenes.

#### Scenario: Fuente externa declarada
- **WHEN** el bootstrap requiere una fuente externa esencial
- **THEN** la configura solo si coincide con su declaración de origen y verificación

#### Scenario: Sheldon disponible
- **WHEN** Homebrew termina correctamente
- **THEN** Sheldon queda disponible para generar o validar el lockfile de plugins antes de iniciar Zsh

#### Scenario: Catálogo de aplicaciones diferido
- **WHEN** finaliza el bootstrap inicial
- **THEN** no instala aplicaciones opcionales, fuentes tipográficas ni AppImages de catálogo

#### Scenario: Inicio de una shell nueva
- **WHEN** una persona abre Bash o Zsh después de instalar Homebrew
- **THEN** `brew` está disponible en `PATH` sin duplicar ni reemplazar contenido de `.bashrc` o `.zshrc`

#### Scenario: Repositorio externo no verificable
- **WHEN** una clave, URL o metadato de un repositorio externo no coincide con la declaración esperada
- **THEN** el bootstrap detiene la fase afectada sin instalar paquetes desde ese origen ni cargar plugins no verificados

### Requirement: Fórmula Homebrew de Firefox PWA
El sistema SHALL declarar `firefoxpwa` en el catálogo Homebrew y comprobar
mediante Homebrew si la fórmula está instalada antes de instalarla.

#### Scenario: Fórmula declarada
- **WHEN** se inspecciona el catálogo Homebrew
- **THEN** incluye `firefoxpwa` como fórmula gestionada para Fedora

#### Scenario: Homebrew no disponible
- **WHEN** Homebrew no queda disponible tras su fase de instalación
- **THEN** Firefox PWA queda registrado como fallido sin detener el resto del catálogo
