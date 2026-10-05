# Spec Delta

## Purpose

Define configuraciones personales reproducibles y portables, sin incorporar
datos de aplicación, credenciales ni estado específico de una estación Fedora.

## ADDED Requirements

### Requirement: Configuraciones portables mediante Dotbot
El sistema SHALL enlazar las configuraciones versionadas de Nano, Vim, Git,
Terminator, Flameshot, Heynote, Input Remapper 2 y msmtp solo cuando el destino
esté ausente o ya sea el enlace gestionado. Los destinos no gestionados SHALL
seguir el mecanismo existente de detección de conflictos y no serán reemplazados.

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
estado de actualización. SHALL conservar una configuración activa de msmtp sin
contraseñas ni tokens.

#### Scenario: Revisión del contenido versionado
- **WHEN** se inspeccionan las configuraciones de aplicación del repositorio
- **THEN** no contienen credenciales SMTP, notas de Heynote, cachés ni estado
  local de Gear Lever

#### Scenario: Configuración IONOS sin credenciales
- **WHEN** el bootstrap enlaza la configuración de msmtp
- **THEN** declara el servidor IONOS y el remitente, pero no contiene usuario,
  contraseña, token ni sesión de Vaultwarden

### Requirement: Credenciales SMTP bajo demanda desde Vaultwarden
El sistema SHALL obtener el usuario y la contraseña de msmtp exclusivamente
desde el ítem `Mail.ionos.es` de Vaultwarden mediante una sesión válida en
GNOME Keyring. La sesión de Vaultwarden SHALL seguir siendo opcional durante el
bootstrap. Si no está disponible al enviar correo, los helpers SHALL fallar sin
emitir secretos ni modificar la configuración.

#### Scenario: Envío con sesión válida
- **WHEN** msmtp necesita autenticar la cuenta IONOS y existe una sesión válida
- **THEN** obtiene los dos valores del ítem `Mail.ionos.es` bajo demanda sin
  guardarlos en disco

#### Scenario: Envío con Vaultwarden bloqueado
- **WHEN** msmtp necesita autenticar la cuenta IONOS y no existe una sesión
  válida en GNOME Keyring
- **THEN** el envío falla con una instrucción para desbloquear Vaultwarden y el
  bootstrap previo permanece conforme

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
