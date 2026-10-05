# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión, VLC, Syncthing, Terminator, Vim, wl-clipboard, pipx, input-remapper, VS Code y Firefox; y las aplicaciones Flatpak acordadas. Firefox PWA SHALL instalarse como el RPM oficial de release declarado y verificado.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin el software declarado
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados, incluido Firefox PWA en su versión declarada, ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

## ADDED Requirements

### Requirement: Firefox PWA desde una release verificable
El sistema SHALL descargar Firefox PWA únicamente desde la release oficial declarada de PWAsForFirefox, comprobar su SHA-256 antes de instalarlo mediante DNF y no configurar el repositorio Packagecloud para este componente.

#### Scenario: RPM de Firefox PWA válido
- **WHEN** el RPM descargado coincide con la versión y SHA-256 declarados
- **THEN** el sistema lo instala y registra Firefox PWA como instalado

#### Scenario: RPM de Firefox PWA no verificable
- **WHEN** la descarga falla o su SHA-256 no coincide con la declaración
- **THEN** el sistema elimina el archivo temporal, no instala Firefox PWA y registra el fallo
