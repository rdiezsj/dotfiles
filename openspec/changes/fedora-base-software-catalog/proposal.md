# Proposal

## Why

El bootstrap ya prepara fuentes y catálogos vacíos, pero una estación Fedora nueva aún requiere instalar y reconciliar manualmente el software base. Este cambio convierte las listas acordadas en un catálogo idempotente, preservando la separación por gestor y evitando aplicaciones duplicadas.

## What Changes

- Ejecutar catálogos declarativos DNF/RPM y Flatpak con los paquetes acordados, sus identificadores explícitos y comprobación idempotente.
- Configurar el repositorio oficial de Microsoft para VS Code y aplicar las sustituciones acordadas: Firefox DNF frente a Firefox Flatpak y ONLYOFFICE frente a LibreOffice o FreeOffice.
- Gestionar la descarga verificable de los AppImage de Heynote y Nextcloud Desktop Client a `~/Apps`. Gear Lever se instalará como gestor visual, pero la importación de cada archivo será una acción manual visible; el bootstrap no asumirá una interfaz de automatización ni rutas internas de Gear Lever.
- Instalar la pila multimedia de RPM Fusion: FFmpeg completo, grupo multimedia, códecs y soporte DVD cuando la fuente RPM Fusion correspondiente esté disponible.
- Detectar una GPU NVIDIA y, solo si existe, instalar el controlador RPM Fusion y las bibliotecas VA-API de 64 y 32 bits; tratar Secure Boot como una intervención humana explícita si requiere enrolar MOK.
- Instalar y habilitar Syncthing como servicio `systemd --user`, asociado al usuario que posee los datos sincronizados.
- Mantener las configuraciones versionables fuera de secretos y preparar su incorporación posterior; este cambio no fija preferencias de Terminator, input-remapper, Heynote, Gear Lever ni otras aplicaciones.
- Mantener Homebrew/Zsh, Starship, plugins y fórmulas de CLI fuera de alcance hasta el siguiente cambio.

## Capabilities

### New Capabilities
- `fedora-software-catalog`: Declara y reconcilia el software base de Fedora desde DNF, Flatpak y AppImage, incluidas sustituciones exclusivas.
- `fedora-multimedia-nvidia`: Prepara codecs multimedia y controladores NVIDIA de RPM Fusion de forma condicional y verificable.

### Modified Capabilities
- `package-sources`: Los catálogos pasan de estar solo preparados a ejecutarse de forma declarativa e idempotente.

## Impact

- Afecta `bootstrap`, los cuatro catálogos, la plataforma Fedora, pruebas unitarias y la documentación.
- Añade el repositorio RPM oficial de Microsoft y, cuando sea necesario para DVD, la fuente RPM Fusion tainted.
- Puede instalar, actualizar, desinstalar o sustituir paquetes y Flatpaks indicados; nunca gestiona archivos de configuración personales no declarados ni secretos.
