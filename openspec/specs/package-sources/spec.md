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
El sistema SHALL mantener catálogos Bash diferenciados para DNF/RPM, Flatpak, Homebrew y AppImage, con comentarios en español que describan la finalidad de cada bloque. SHALL ejecutar de forma idempotente los catálogos DNF/RPM, Flatpak y AppImage aprobados, mientras que Homebrew permanecerá declarado sin instalar sus fórmulas de Zsh en esta iteración.

#### Scenario: Revisión de catálogos
- **WHEN** se inspecciona la configuración de catálogos
- **THEN** cada tecnología dispone de un bloque separado y comentado en español

#### Scenario: Ejecución del catálogo aprobado
- **WHEN** se confirma el bootstrap con un catálogo DNF, Flatpak o AppImage aprobado
- **THEN** instala únicamente los elementos declarados por ese gestor

### Requirement: Homebrew y fuentes externas esenciales
El sistema SHALL instalar Homebrew, su grupo `development-tools` requerido en Fedora y configurar las fuentes externas declaradas necesarias para el bootstrap, verificando su origen y sin instalar fórmulas Homebrew de catálogo no esenciales. Tras la instalación SHALL activar Homebrew en la sesión actual y mantener bloques idempotentes para Bash y Zsh sin reemplazar el contenido ajeno de sus archivos de inicio. SHALL configurar además el repositorio oficial de Microsoft para VS Code y las fuentes RPM Fusion necesarias para multimedia, DVD y NVIDIA solo tras validar sus orígenes.

#### Scenario: Fuente externa declarada
- **WHEN** el bootstrap requiere una fuente externa esencial
- **THEN** la configura solo si coincide con su declaración de origen y verificación

#### Scenario: Catálogo de aplicaciones diferido
- **WHEN** finaliza el bootstrap inicial
- **THEN** no instala aplicaciones opcionales, fuentes tipográficas ni AppImages de catálogo

#### Scenario: Inicio de una shell nueva
- **WHEN** una persona abre Bash o Zsh después de instalar Homebrew
- **THEN** `brew` está disponible en `PATH` sin duplicar ni reemplazar contenido de `.bashrc` o `.zshrc`

#### Scenario: Repositorio externo no verificable
- **WHEN** una clave, URL o metadato de un repositorio externo no coincide con la declaración esperada
- **THEN** el sistema detiene la fase afectada sin instalar paquetes desde ese origen
