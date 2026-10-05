# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak
declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión,
VLC, Syncthing, Terminator, Nano, Vim, wl-clipboard, pipx, input-remapper,
msmtp, Flameshot, VS Code, Firefox y Firefox PWA; y las aplicaciones Flatpak
acordadas.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin esos paquetes
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

#### Scenario: Cliente SMTP disponible
- **WHEN** finaliza correctamente el catálogo DNF en una estación nueva
- **THEN** `msmtp` queda instalado sin requerir fuentes externas adicionales
