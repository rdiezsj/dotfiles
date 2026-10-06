# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión, VLC, Syncthing, Terminator, Vim, wl-clipboard, pipx, input-remapper, VS Code y Firefox; y las aplicaciones Flatpak acordadas. Firefox PWA SHALL instalarse mediante su fórmula Homebrew declarada.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin el software declarado
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados, incluida la fórmula Firefox PWA, ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

## ADDED Requirements

### Requirement: Firefox PWA desde Homebrew
El sistema SHALL instalar Firefox PWA exclusivamente mediante la fórmula `firefoxpwa` de Homebrew y no SHALL configurar Packagecloud ni descargar RPMs directamente para este componente.

#### Scenario: Fórmula Firefox PWA ausente
- **WHEN** la fórmula `firefoxpwa` no está instalada tras preparar Homebrew
- **THEN** el sistema la instala y registra Firefox PWA como instalado

#### Scenario: Fórmula Firefox PWA ya presente
- **WHEN** la fórmula `firefoxpwa` ya está instalada
- **THEN** el sistema la comunica como presente sin reinstalarla
