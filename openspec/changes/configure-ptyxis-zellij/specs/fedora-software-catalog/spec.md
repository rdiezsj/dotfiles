# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak
declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión,
VLC, Syncthing, Terminator, Ptyxis, Dconf, Nano, Vim, wl-clipboard, pipx,
input-remapper, msmtp, Flameshot, VS Code y Firefox; y las aplicaciones
Flatpak acordadas. Firefox PWA y Zellij SHALL instalarse mediante sus fórmulas
Homebrew declaradas. Tras su instalación, el sistema SHALL validar que Ptyxis
y Zellij están disponibles para el usuario que ejecuta el bootstrap.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin el software declarado
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados, incluidas las fórmulas Firefox PWA y Zellij, ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

#### Scenario: Cliente SMTP disponible
- **WHEN** finaliza correctamente el catálogo DNF en una estación nueva
- **THEN** `msmtp` queda instalado sin requerir fuentes externas adicionales

#### Scenario: Herramientas de terminal disponibles
- **WHEN** finalizan correctamente los catálogos DNF y Homebrew en una estación nueva
- **THEN** las comprobaciones de Ptyxis y Zellij confirman que ambos binarios están disponibles
