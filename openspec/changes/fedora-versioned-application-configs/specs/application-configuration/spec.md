# Spec Delta

## Purpose

Define configuraciones personales reproducibles y portables, sin incorporar
datos de aplicación, credenciales ni estado específico de una estación Fedora.

## ADDED Requirements

### Requirement: Configuraciones portables mediante Dotbot
El sistema SHALL enlazar las configuraciones versionadas de Nano, Vim, Git,
Terminator, Flameshot, Heynote e Input Remapper 2 solo cuando el destino esté
ausente o ya sea el enlace gestionado. Los destinos no gestionados SHALL seguir
el mecanismo existente de detección de conflictos y no serán reemplazados.

#### Scenario: Estación nueva sin configuraciones
- **WHEN** el bootstrap aplica Dotbot sobre una estación Fedora nueva
- **THEN** las configuraciones portables declaradas quedan disponibles en sus
  rutas de usuario XDG o de HOME

#### Scenario: Configuración local no gestionada
- **WHEN** existe un archivo de configuración distinto en un destino declarado
- **THEN** el bootstrap informa del conflicto y conserva el archivo local

### Requirement: Separación de datos locales y credenciales
El repositorio SHALL incluir únicamente `config.json` y `Preferences` de
Heynote, y SHALL excluir notas, buffers, sesiones y cachés. SHALL excluir el
sandbox completo de Gear Lever, sus AppImages integrados, rutas, inventario y
estado de actualización. SHALL conservar msmtp solo como plantilla sin valores
de cuenta, contraseñas, tokens ni configuración operativa.

#### Scenario: Revisión del contenido versionado
- **WHEN** se inspeccionan las configuraciones de aplicación del repositorio
- **THEN** no contienen credenciales SMTP, notas de Heynote, cachés ni estado
  local de Gear Lever

#### Scenario: Plantilla de msmtp pendiente
- **WHEN** la plantilla de msmtp aún no contiene parámetros personales
- **THEN** el bootstrap no crea ni activa una configuración SMTP incompleta

### Requirement: Preferencias personales diferidas
El sistema SHALL proporcionar configuraciones base funcionales para Nano, Vim y
Flameshot sin fijar valores personales pendientes, incluidos el tamaño de
tabulación y la ruta de capturas. Las opciones pendientes SHALL quedar
identificadas como plantilla o comentario para una personalización posterior.

#### Scenario: Bootstrap antes de completar preferencias
- **WHEN** se ejecuta el bootstrap con las preferencias personales sin rellenar
- **THEN** instala y enlaza la configuración base sin solicitar esos valores ni
  dejar archivos de sintaxis inválida

### Requirement: Input Remapper sin asociación de hardware implícita
El sistema SHALL versionar una configuración base y los presets explícitamente
declarados de Input Remapper 2, pero SHALL dejar vacío el autoload inicial para
no asociar un remapeo a un dispositivo no verificado.

#### Scenario: Equipo con dispositivos diferentes
- **WHEN** el bootstrap se ejecuta en un equipo que no tiene el dispositivo
  usado al definir un preset
- **THEN** no activa automáticamente ningún remapeo para ese dispositivo
