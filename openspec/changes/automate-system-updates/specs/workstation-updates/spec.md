# Spec Delta

## Purpose

Centraliza el mantenimiento no interactivo y verificable de una estación Fedora
desplegada a partir de los dotfiles y sus fuentes de software declaradas.

## ADDED Requirements

### Requirement: Invocación no interactiva de actualización
El sistema SHALL proporcionar el alias Zsh `update`, que ejecutará la rutina de
actualización sin solicitar confirmaciones interactivas. La rutina SHALL mostrar
sus fases en español, no expondrá secretos y terminará con estado no nulo si
alguna fase no se completa.

#### Scenario: Actualización desde una sesión Zsh
- **WHEN** la persona ejecuta `update` en una estación desplegada compatible
- **THEN** la rutina inicia la actualización sin solicitar confirmación y muestra
  el resultado de cada fase

#### Scenario: Incidencia parcial
- **WHEN** una de las fuentes gestionadas no puede actualizarse
- **THEN** la rutina completa las fases independientes restantes, informa de la
  incidencia y termina con estado no nulo

### Requirement: Sincronización segura del checkout y configuraciones
La rutina SHALL actualizar el checkout desplegado desde su remoto y referencia
configurados mediante un avance rápido que no sobrescriba trabajo local. Tras
una sincronización correcta SHALL aplicar las configuraciones declaradas cuya
fuente versionada haya cambiado; no SHALL reemplazar una configuración local no
gestionada y comunicará ese conflicto como incidencia.

#### Scenario: Checkout desplegado conforme
- **WHEN** el checkout desplegado no contiene cambios locales incompatibles
- **THEN** la rutina lo sincroniza con su remoto configurado y aplica las
  configuraciones declaradas actualizadas

#### Scenario: Checkout con cambios locales
- **WHEN** el checkout desplegado contiene cambios locales o no admite avance
  rápido hacia su referencia remota
- **THEN** la rutina no descarta ni sobrescribe esos cambios y termina la fase
  de sincronización como fallida

#### Scenario: Configuración local no gestionada
- **WHEN** una configuración declarada tiene un destino local que no es un
  enlace gestionado por los dotfiles
- **THEN** la rutina conserva el destino, informa del conflicto y no lo
  reemplaza automáticamente

### Requirement: Actualización de fuentes de software gestionadas
La rutina SHALL actualizar sin confirmación los paquetes y metadatos DNF,
fórmulas Homebrew y Flatpak de usuario disponibles. SHALL actualizar las
extensiones GNOME y los AppImage que el repositorio declare, solo cuando su
origen, compatibilidad y verificación permitan sustituirlos con seguridad; no
SHALL gestionar aplicaciones, extensiones ni AppImage locales no declarados.

#### Scenario: Fuentes declaradas actualizables
- **WHEN** las fuentes DNF, Homebrew, Flatpak, extensiones GNOME o AppImage
  declaradas ofrecen una actualización verificable y compatible
- **THEN** la rutina la instala sin pedir confirmación y la informa en su
  resumen

#### Scenario: AppImage o extensión no verificable
- **WHEN** un AppImage o una extensión GNOME declarada no tiene una actualización
  verificable o compatible con la estación
- **THEN** la rutina conserva la versión existente, informa de la incidencia y
  no instala contenido no verificado

#### Scenario: Elemento local fuera del catálogo
- **WHEN** Gear Lever o GNOME contienen un AppImage o una extensión no declarados
  por el repositorio
- **THEN** la rutina no los modifica ni los presenta como actualizados

### Requirement: Resumen de mantenimiento
La rutina SHALL resumir el resultado de la sincronización del checkout, las
configuraciones y cada gestor cubierto. El resumen SHALL distinguir elementos
actualizados, ya conformes, omitidos y fallidos, e indicará cuando DNF comunique
un reinicio recomendado sin reiniciar el equipo.

#### Scenario: Actualización que requiere reinicio
- **WHEN** DNF comunica que una actualización instalada requiere reiniciar
- **THEN** el resumen lo indica y la rutina no reinicia el equipo
