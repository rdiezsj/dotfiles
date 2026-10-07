# Design

## Context

El catálogo ya descarga AppImages a `~/Apps` y Gear Lever se instala como
Flatpak. La configuración actual de Gear Lever se guarda en GSettings dentro
del sandbox Flatpak: su clave `appimages-default-folder` parte de
`~/AppImages`. El mensaje adjunto corresponde a la detección que hace Gear
Lever al ejecutar un AppImage v2 cuando falta FUSE en el host.

## Goals / Non-Goals

**Goals:**

- Declarar una única preferencia portable para alinear Gear Lever con el
  directorio gestionado por el catálogo.
- Aplicarla después de instalar el Flatpak, de forma repetible y sin depender
  de un perfil dconf binario preexistente.
- Añadir al catálogo DNF la compatibilidad FUSE de AppImage v2 y comprobar que
  el host expone la biblioteca esperada.

**Non-Goals:**

- Importar, mover o integrar AppImages automáticamente.
- Versionar el sandbox, el inventario, rutas particulares, ajustes de
  actualización, registros o cachés de Gear Lever.
- Sustituir Gear Lever ni modificar los AppImages declarados.

## Decisions

### Declaración ejecutable de GSettings

Se versionará un helper pequeño que establezca la clave de GSettings mediante
el Flatpak ya instalado y reciba el directorio de HOME en tiempo de ejecución.
El bootstrap lo ejecutará tras el catálogo Flatpak; si Gear Lever no quedó
instalado, registrará el fallo de esa fase sin simular que la preferencia se
aplicó.

Se descarta versionar directamente el fichero dconf del sandbox: es binario,
contiene otras preferencias locales y su ruta depende de Flatpak. También se
descarta enlazar `gearlever.conf`, porque contiene estado por AppImage y no la
preferencia de carpeta.

### Directorio resuelto desde HOME

La declaración conservará `$HOME/Apps` como intención portable y el helper
resolverá el HOME del usuario que ejecuta el bootstrap antes de escribir
GSettings. Así no se versiona una ruta absoluta de una estación concreta.

### Configuraciones de aplicación explícitamente elegidas

Los ficheros de Heynote y Flameshot que la persona usuaria ha creado a mano
son la fuente de verdad y se versionarán sin normalizarlos ni filtrarlos.
Input Remapper se enlazará como directorio completo para que su `config.json`
y todos los presets versionados se desplieguen juntos. Se descarta enlazar solo
su fichero principal porque dejaría fuera los perfiles definidos.

### FUSE de compatibilidad en el catálogo DNF

El catálogo DNF declarará el paquete Fedora que proporciona la ABI FUSE 2 que
necesitan los AppImage v2. Su instalación reutilizará las comprobaciones
idempotentes del catálogo y la prueba validará la disponibilidad de
`libfuse.so.2`, no solo la presencia nominal del paquete.

Se descarta usar `--appimage-extract-and-run`: es una solución por aplicación,
no restaura la ejecución normal ni soluciona la dependencia durante el
bootstrap.

## Risks / Trade-offs

- [El nombre del paquete Fedora o su ABI cambia] → La implementación verificará
  el proveedor en Fedora antes de declararlo y las pruebas comprobarán la
  biblioteca requerida.
- [Gear Lever cambia el esquema GSettings] → El helper fallará de forma visible
  y la validación comprobará la clave antes de declararlo conforme.
- [Una configuración local distinta] → La única clave acordada se aplica de
  forma determinista; el resto del sandbox permanece intacto.
- [Un fichero de preferencias contiene estado de aplicación] → Se conserva
  únicamente porque la persona usuaria lo ha seleccionado expresamente; no se
  añaden ficheros vecinos ni directorios de datos.

## Migration Plan

1. Añadir la declaración y el helper, y conectarlo después de la instalación
   Flatpak de Gear Lever.
2. Incluir la dependencia FUSE y sus comprobaciones en el catálogo DNF.
3. Enlazar los ficheros declarados de Heynote y Flameshot y el directorio de
   Input Remapper 2 completo.
4. Ejecutar pruebas unitarias, `scripts/check.sh` y la validación estricta de
   OpenSpec.
5. En estaciones ya configuradas, una nueva ejecución actualiza solo la clave
   de carpeta predeterminada; el resto de datos locales no se toca.
