# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión, VLC, Syncthing, Terminator, Nano, Vim, wl-clipboard, pipx, input-remapper, msmtp, Flameshot, VS Code y Firefox; las aplicaciones Flatpak acordadas; AppIndicator, Dash to Dock, `libgtop2-devel` y `lm_sensors` desde DNF. Firefox PWA SHALL instalarse mediante su fórmula Homebrew declarada.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin el software declarado
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados, incluidos los paquetes DNF de soporte de extensiones GNOME

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados, incluida la fórmula Firefox PWA, ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

#### Scenario: Cliente SMTP disponible
- **WHEN** finaliza correctamente el catálogo DNF en una estación nueva
- **THEN** `msmtp` queda instalado sin requerir fuentes externas adicionales
