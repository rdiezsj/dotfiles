# Spec Delta

## MODIFIED Requirements

### Requirement: Configuraciones portables mediante Dotbot
El sistema SHALL enlazar las configuraciones versionadas de Nano, Vim, Git, Terminator, Flameshot, Heynote, Input Remapper 2 y msmtp solo cuando el destino esté ausente o ya sea el enlace gestionado. Para Terminator, la configuración incluye su lanzador de usuario y su entrada de escritorio, que SHALL iniciar la aplicación con `Adwaita:dark` sin modificar el tema de otras aplicaciones GTK. Los destinos no gestionados SHALL seguir el mecanismo existente de detección de conflictos y no serán reemplazados.

#### Scenario: Estación nueva sin configuraciones
- **WHEN** el bootstrap aplica Dotbot sobre una estación Fedora nueva
- **THEN** las configuraciones portables declaradas quedan disponibles en sus rutas de usuario XDG o de HOME

#### Scenario: Configuración local no gestionada
- **WHEN** existe un archivo de configuración distinto en un destino declarado
- **THEN** el bootstrap informa del conflicto y conserva el archivo local

#### Scenario: Inicio de Terminator desde el menú y la terminal
- **WHEN** el bootstrap ha enlazado la configuración de Terminator en una estación con Terminator instalado
- **THEN** tanto el menú de GNOME como el comando `terminator` lo inician con `Adwaita:dark` sin cambiar el tema de otras aplicaciones GTK
