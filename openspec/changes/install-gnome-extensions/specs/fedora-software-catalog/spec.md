# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión, VLC, Syncthing, Terminator, Nano, Vim, wl-clipboard, pipx, input-remapper, msmtp, Flameshot, VS Code y Firefox; y las aplicaciones Flatpak acordadas, incluida GNOME Extensions mediante `org.gnome.Extensions`. Antes de instalar el catálogo Flatpak, SHALL asegurar que el remoto de usuario `flathub` usa `https://flathub.org/repo/flathub.flatpakrepo`. Firefox PWA SHALL instalarse mediante su fórmula Homebrew declarada.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin el software declarado
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados, incluida GNOME Extensions desde Flathub

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados, incluida GNOME Extensions y la fórmula Firefox PWA, ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

#### Scenario: Remoto Flathub ausente o con un origen distinto
- **WHEN** el remoto de usuario `flathub` no existe o no apunta a `https://flathub.org/repo/flathub.flatpakrepo`
- **THEN** el sistema lo configura con esa URL antes de instalar aplicaciones Flatpak declaradas

#### Scenario: Cliente SMTP disponible
- **WHEN** finaliza correctamente el catálogo DNF en una estación nueva
- **THEN** `msmtp` queda instalado sin requerir fuentes externas adicionales
