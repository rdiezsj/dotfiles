# package-sources Specification Delta

## MODIFIED Requirements

### Requirement: Catálogos base separados
El sistema SHALL mantener catálogos Bash diferenciados para DNF/RPM, Flatpak, Homebrew y AppImage, con comentarios en español que describan la finalidad de cada bloque. SHALL ejecutar de forma idempotente los catálogos aprobados y SHALL declarar Sheldon como la única dependencia Homebrew de gestión de plugins Zsh; las fórmulas de plugins Zsh no se duplicarán en el catálogo Homebrew.

#### Scenario: Revisión de catálogos
- **WHEN** se inspecciona la configuración de catálogos
- **THEN** cada tecnología dispone de un bloque separado y Sheldon aparece como dependencia de gestión, mientras que los plugins se declaran en su configuración

#### Scenario: Ejecución idempotente
- **WHEN** se confirma el bootstrap varias veces
- **THEN** Homebrew, Sheldon y los plugins ya satisfechos no se reinstalan ni sobrescriben configuraciones gestionadas

#### Scenario: Ejecución del catálogo aprobado
- **WHEN** se confirma el bootstrap con un catálogo DNF, Flatpak, Homebrew o AppImage aprobado
- **THEN** instala únicamente los elementos declarados por ese gestor

### Requirement: Homebrew y fuentes externas esenciales
El sistema SHALL instalar Homebrew, su grupo `development-tools` requerido en Fedora y configurar las fuentes externas declaradas necesarias para el bootstrap, incluyendo Sheldon, verificando su origen y sin instalar fórmulas Homebrew de catálogo no esenciales. Tras la instalación SHALL activar Homebrew en la sesión actual y mantener bloques idempotentes para Bash y Zsh sin reemplazar el contenido ajeno de sus archivos de inicio. SHALL configurar además el repositorio oficial de Microsoft para VS Code y las fuentes RPM Fusion necesarias para multimedia, DVD y NVIDIA solo tras validar sus orígenes.

#### Scenario: Sheldon disponible
- **WHEN** Homebrew termina correctamente
- **THEN** Sheldon queda disponible para generar o validar el lockfile de plugins antes de iniciar Zsh

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
- **THEN** el bootstrap detiene la fase afectada sin instalar paquetes desde ese origen ni cargar plugins no verificados
