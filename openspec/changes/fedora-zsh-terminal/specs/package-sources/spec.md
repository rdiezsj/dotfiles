# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos base separados
El sistema SHALL mantener catálogos Bash diferenciados para DNF/RPM, Flatpak, Homebrew y AppImage, con comentarios en español que describan la finalidad de cada bloque. SHALL ejecutar de forma idempotente los catálogos DNF/RPM, Flatpak, Homebrew y AppImage aprobados.

#### Scenario: Revisión de catálogos
- **WHEN** se inspecciona la configuración de catálogos
- **THEN** cada tecnología dispone de un bloque separado y comentado en español

#### Scenario: Ejecución del catálogo aprobado
- **WHEN** se confirma el bootstrap con un catálogo DNF, Flatpak, Homebrew o AppImage aprobado
- **THEN** instala únicamente los elementos declarados por ese gestor

### Requirement: Homebrew y fuentes externas esenciales
El sistema SHALL instalar Homebrew, su grupo `development-tools` requerido en Fedora y configurar las fuentes externas declaradas necesarias para el bootstrap, verificando su origen. Tras la instalación SHALL activar Homebrew en la sesión actual y mantener un bloque idempotente para Bash sin reemplazar contenido ajeno. SHALL instalar de forma idempotente las fórmulas declaradas Firefox PWA, Starship, `zsh-completions`, fzf, Helm, `kubernetes-cli`, kubectx y tldr; Zsh activará Homebrew desde sus archivos versionados.

#### Scenario: Fuente externa declarada
- **WHEN** el bootstrap requiere una fuente externa esencial
- **THEN** la configura solo si coincide con su declaración de origen y verificación

#### Scenario: Fórmula Homebrew declarada
- **WHEN** una fórmula de terminal aprobada no está instalada
- **THEN** Homebrew la instala y el resumen la registra como instalada

#### Scenario: Fórmula Homebrew ya presente
- **WHEN** una fórmula de terminal aprobada ya está instalada
- **THEN** el sistema la comunica como presente sin reinstalarla

#### Scenario: Catálogo de aplicaciones diferido
- **WHEN** finaliza el bootstrap inicial
- **THEN** no instala aplicaciones opcionales, fuentes tipográficas ni AppImages de catálogo

#### Scenario: Inicio de una shell nueva
- **WHEN** una persona abre Bash o Zsh después de instalar Homebrew
- **THEN** `brew` está disponible en `PATH` sin duplicar contenido de `.bashrc` y desde la configuración Zsh versionada

#### Scenario: Repositorio externo no verificable
- **WHEN** una clave, URL o metadato de un repositorio externo no coincide con la declaración esperada
- **THEN** el sistema detiene la fase afectada sin instalar paquetes desde ese origen
