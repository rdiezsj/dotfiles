# Spec Delta

## Purpose

Instala y reconcilia de forma declarativa el software base de una estación Fedora, conservando un único origen para cada aplicación.

## ADDED Requirements

### Requirement: Catálogos ejecutables por gestor
El sistema SHALL instalar de forma idempotente los paquetes DNF y Flatpak declarados para la estación Fedora, incluidos GNOME Tweaks, Sushi, compresión, VLC, Syncthing, Terminator, Vim, wl-clipboard, pipx, input-remapper, VS Code, Firefox y Firefox PWA; y las aplicaciones Flatpak acordadas.

#### Scenario: Equipo sin el software base
- **WHEN** se confirma el catálogo en una Fedora compatible sin esos paquetes
- **THEN** el sistema instala cada elemento desde el gestor y origen declarados

#### Scenario: Segunda ejecución
- **WHEN** todos los elementos declarados ya están instalados
- **THEN** el sistema los comunica como presentes sin reinstalarlos

### Requirement: Origen único de aplicaciones excluyentes
El sistema SHALL conservar Firefox instalado desde DNF y ONLYOFFICE desde Flathub, y SHALL retirar las variantes Firefox Snap o Flatpak, LibreOffice y FreeOffice detectadas antes de declarar conforme el catálogo.

#### Scenario: Sustitución de Firefox
- **WHEN** se detecta Firefox en Snap o Flatpak
- **THEN** el sistema lo retira y deja instalado el paquete Firefox de DNF

#### Scenario: Sustitución de suite ofimática
- **WHEN** se detecta LibreOffice o FreeOffice junto a ONLYOFFICE
- **THEN** el sistema retira las suites alternativas y deja ONLYOFFICE de Flathub

### Requirement: VS Code desde el repositorio oficial
El sistema SHALL configurar el repositorio RPM oficial de Microsoft con comprobación GPG antes de instalar VS Code mediante DNF.

#### Scenario: Repositorio no configurado
- **WHEN** el catálogo requiere VS Code y el repositorio oficial no existe
- **THEN** el sistema instala la clave y declaración de repositorio oficiales antes de instalar el paquete

### Requirement: AppImage declarados y verificables
El sistema SHALL descargar Heynote y Nextcloud Desktop Client a `~/Apps` únicamente desde sus fuentes oficiales, con versión y suma SHA-256 declaradas, sin sobrescribir una descarga local no gestionada. SHALL instalar Gear Lever como gestor visual, pero no SHALL importar ni mover automáticamente los AppImage: SHALL comunicar en el resumen la ruta exacta que la persona usuaria debe importar manualmente.

#### Scenario: AppImage nuevo
- **WHEN** el AppImage declarado no está presente en `~/Apps`
- **THEN** el sistema descarga, verifica la suma y conserva el archivo ejecutable en esa ruta

#### Scenario: AppImage listo para Gear Lever
- **WHEN** un AppImage declarado queda verificado o ya estaba verificado en `~/Apps`
- **THEN** el resumen informa de que debe importarse manualmente desde esa ruta en Gear Lever, sin modificarlo

#### Scenario: Descarga no verificable
- **WHEN** la versión o suma declaradas no coinciden con el archivo descargado
- **THEN** el sistema elimina la descarga temporal, no modifica `~/Apps` y explica el fallo

### Requirement: Servicio Syncthing del usuario
El sistema SHALL habilitar e iniciar Syncthing como servicio `systemd --user` para el usuario que ejecuta el bootstrap.

#### Scenario: Syncthing instalado
- **WHEN** el paquete Syncthing queda disponible
- **THEN** su unidad de usuario queda habilitada e iniciada sin ejecutar el servicio como root
