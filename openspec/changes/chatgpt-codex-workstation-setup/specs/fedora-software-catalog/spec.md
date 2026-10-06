# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión, VLC, Syncthing, Terminator, Nano, Vim, wl-clipboard, pipx, input-remapper, msmtp, Flameshot, VS Code y Firefox; y las aplicaciones Flatpak acordadas. Firefox PWA SHALL instalarse mediante su fórmula Homebrew declarada. OpenSpec SHALL estar disponible como CLI global mediante Homebrew cuando no haya ya una instalación global funcional.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin el software declarado
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados, incluida la fórmula Firefox PWA, ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

#### Scenario: OpenSpec global ya disponible
- **WHEN** el comando global `openspec` está disponible y devuelve una versión
- **THEN** el catálogo lo comunica como presente sin instalar otra copia ni cambiar su gestor

#### Scenario: OpenSpec global ausente
- **WHEN** el comando `openspec` no está disponible
- **THEN** el sistema instala la fórmula Homebrew `openspec` y registra la CLI como instalada

#### Scenario: Cliente SMTP disponible
- **WHEN** finaliza correctamente el catálogo DNF en una estación nueva
- **THEN** `msmtp` queda instalado sin requerir fuentes externas adicionales

## ADDED Requirements

### Requirement: ChatGPT de escritorio para Fedora
El sistema SHALL instalar ChatGPT para Linux desde el RPM oficial de OpenAI en las versiones Fedora y arquitecturas que OpenAI declare compatibles.

#### Scenario: ChatGPT ausente en Fedora compatible
- **WHEN** se confirma el catálogo en una versión Fedora compatible y `chatgpt` no está instalado
- **THEN** el sistema selecciona el RPM oficial para la arquitectura del equipo, lo instala con DNF y comprueba que el paquete quedó instalado

#### Scenario: ChatGPT ya instalado
- **WHEN** el paquete `chatgpt` ya está instalado
- **THEN** el sistema lo comunica como presente y no vuelve a instalar el RPM

#### Scenario: Fedora o arquitectura no compatible
- **WHEN** la versión Fedora o arquitectura del equipo no está declarada como compatible por OpenAI
- **THEN** el sistema omite la instalación, informa del motivo y no descarga ni instala un paquete distinto
