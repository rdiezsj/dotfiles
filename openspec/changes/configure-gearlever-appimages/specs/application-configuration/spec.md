# Spec Delta

## MODIFIED Requirements

### Requirement: Configuraciones portables mediante Dotbot
El sistema SHALL enlazar las configuraciones versionadas de Nano, Vim, Git, Terminator, Flameshot, Heynote, Input Remapper 2 y msmtp solo cuando el destino esté ausente o ya sea el enlace gestionado. Input Remapper 2 SHALL enlazarse como directorio completo, incluidos los presets declarados. Los destinos no gestionados SHALL seguir el mecanismo existente de detección de conflictos y no serán reemplazados. Tras instalar Gear Lever desde Flatpak, el bootstrap SHALL aplicar su preferencia portable de carpeta predeterminada de AppImage con el valor `$HOME/Apps`.

#### Scenario: Estación nueva sin configuraciones
- **WHEN** el bootstrap aplica Dotbot sobre una estación Fedora nueva
- **THEN** las configuraciones portables declaradas quedan disponibles en sus rutas de usuario XDG o de HOME

#### Scenario: Configuración local no gestionada
- **WHEN** existe un archivo de configuración distinto en un destino declarado
- **THEN** el bootstrap informa del conflicto y conserva el archivo local

#### Scenario: Gear Lever disponible
- **WHEN** el catálogo Flatpak deja instalado Gear Lever durante el bootstrap
- **THEN** su carpeta predeterminada de AppImage queda configurada como `$HOME/Apps`

#### Scenario: Presets de Input Remapper disponibles
- **WHEN** el bootstrap aplica Dotbot en una estación sin configuración de Input Remapper 2
- **THEN** quedan disponibles tanto `config.json` como los presets versionados bajo `~/.config/input-remapper-2`

### Requirement: Separación de datos locales y credenciales
El repositorio SHALL incluir únicamente `config.json` y `Preferences` de Heynote, y SHALL excluir sus notas, buffers y cachés externos. SHALL excluir el sandbox completo de Gear Lever, sus AppImages integrados, rutas, inventario y estado de actualización, salvo la declaración versionada necesaria para aplicar su carpeta predeterminada. SHALL conservar una configuración activa de msmtp sin contraseñas ni tokens.

#### Scenario: Revisión del contenido versionado
- **WHEN** se inspeccionan las configuraciones de aplicación del repositorio
- **THEN** no contienen credenciales SMTP, notas de Heynote, cachés ni estado local de Gear Lever

#### Scenario: Configuración IONOS sin credenciales
- **WHEN** el bootstrap enlaza la configuración de msmtp
- **THEN** declara el servidor IONOS y el remitente, pero no contiene usuario, contraseña, token ni sesión de Vaultwarden

#### Scenario: Preferencia de Gear Lever declarada
- **WHEN** se revisa la configuración versionada de Gear Lever
- **THEN** declara únicamente la carpeta predeterminada `$HOME/Apps` y no incorpora inventario, rutas por aplicación ni datos de actualización

#### Scenario: Ficheros exactos de Heynote
- **WHEN** se revisa la configuración versionada de Heynote
- **THEN** contiene los ficheros `config.json` y `Preferences` creados manualmente, sin añadir otros ficheros de su directorio de configuración

### Requirement: Preferencias personales diferidas
El sistema SHALL proporcionar configuraciones base funcionales para Nano y Vim sin fijar valores personales pendientes, incluidos el tamaño de tabulación. Flameshot SHALL versionar el fichero de preferencias creado manualmente, incluida su ruta de guardado y el arranque automático. Las opciones pendientes de Nano y Vim SHALL quedar identificadas como plantilla o comentario para una personalización posterior.

#### Scenario: Bootstrap antes de completar preferencias
- **WHEN** se ejecuta el bootstrap con las preferencias personales de Nano y Vim sin rellenar
- **THEN** instala y enlaza la configuración base sin solicitar esos valores ni dejar archivos de sintaxis inválida

#### Scenario: Bootstrap con preferencias concretas de Flameshot
- **WHEN** se ejecuta el bootstrap en una estación sin configuración de Flameshot
- **THEN** enlaza el fichero de preferencias versionado con la ruta de guardado y el arranque automático definidos por la persona usuaria
