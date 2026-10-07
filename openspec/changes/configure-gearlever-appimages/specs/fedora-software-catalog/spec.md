# Spec Delta

## MODIFIED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión, VLC, Syncthing, Terminator, Nano, Vim, wl-clipboard, pipx, input-remapper, msmtp, Flameshot, VS Code, Firefox y la compatibilidad FUSE requerida por AppImage v2; y las aplicaciones Flatpak acordadas. Firefox PWA SHALL instalarse mediante su fórmula Homebrew declarada.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin el software declarado
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados, incluida la fórmula Firefox PWA, ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

#### Scenario: Cliente SMTP disponible
- **WHEN** finaliza correctamente el catálogo DNF en una estación nueva
- **THEN** `msmtp` queda instalado sin requerir fuentes externas adicionales

#### Scenario: Compatibilidad AppImage v2 disponible
- **WHEN** finaliza correctamente el catálogo DNF en una estación nueva
- **THEN** queda disponible la biblioteca FUSE de compatibilidad necesaria para ejecutar un AppImage v2 desde Gear Lever

### Requirement: AppImage declarados y verificables
El sistema SHALL descargar Heynote y Nextcloud Desktop Client a `~/Apps` únicamente desde sus fuentes oficiales, con versión y suma SHA-256 declaradas, sin sobrescribir una descarga local no gestionada. SHALL instalar Gear Lever como gestor visual, configurarlo para usar `~/Apps` como carpeta predeterminada y no SHALL importar ni mover automáticamente los AppImage: SHALL comunicar en el resumen la ruta exacta que la persona usuaria debe importar manualmente.

#### Scenario: AppImage nuevo
- **WHEN** el AppImage declarado no está presente en `~/Apps`
- **THEN** el sistema descarga, verifica la suma y conserva el archivo ejecutable en esa ruta

#### Scenario: AppImage listo para Gear Lever
- **WHEN** un AppImage declarado queda verificado o ya estaba verificado en `~/Apps`
- **THEN** Gear Lever usa `~/Apps` como carpeta predeterminada y el resumen informa de que debe importarse manualmente desde esa ruta, sin modificarlo

#### Scenario: Descarga no verificable
- **WHEN** la versión o suma declaradas no coinciden con el archivo descargado
- **THEN** el sistema elimina la descarga temporal, no modifica `~/Apps` y explica el fallo
