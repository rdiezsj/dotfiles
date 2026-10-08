# zsh-terminal-environment Specification

## Purpose

Proporciona una terminal Zsh reproducible para Fedora con herramientas CLI,
prompt y completado, sin conservar datos sensibles ni sobrescribir
configuración no gestionada.

## Requirements

### Requirement: Entorno Zsh versionado
El sistema SHALL enlazar `.zshrc`, `.zsh_aliases`, `.profile`, `.zprofile` y
`home/.config/starship.toml` versionados mediante Dotbot, dejando este último en
`~/.config/starship.toml`. SHALL crear un respaldo fechado y recuperable antes
de sustituir un destino existente no gestionado durante la migración confirmada.

#### Scenario: Destinos de shell ausentes
- **WHEN** no existen los archivos de inicio de shell en el HOME
- **THEN** Dotbot crea los enlaces gestionados y una nueva sesión Zsh carga Homebrew, Starship, completado, alias y fzf

#### Scenario: Destino de shell no gestionado
- **WHEN** existe un archivo o enlace de shell que no pertenece al repositorio
- **THEN** el sistema crea un respaldo fechado, comunica su ruta y sustituye el destino dentro de la migración confirmada

### Requirement: Herramientas interactivas de la terminal
El sistema SHALL inicializar Homebrew, historial, alias, Starship,
`zsh-completions` y fzf desde los archivos de inicio correspondientes, sin
emitir salida ni modificar PATH en sesiones Zsh no interactivas. SHALL ofrecer
el alias `activar-extensiones-gnome` para completar la activación diferida de
las extensiones GNOME declaradas.

#### Scenario: Nueva sesión interactiva
- **WHEN** se abre una sesión Zsh interactiva tras instalar las fórmulas declaradas
- **THEN** están disponibles el prompt Starship, el completado, los atajos de fzf y el alias `activar-extensiones-gnome`

#### Scenario: Ejecución no interactiva
- **WHEN** Zsh ejecuta un comando no interactivo
- **THEN** la configuración no imprime elementos visuales ni bloquea la ejecución

### Requirement: Cambio de shell con consentimiento
El sistema SHALL preguntar de forma explícita antes de ejecutar `chsh` para
establecer Zsh como shell predeterminada y SHALL registrar la decisión en el
resumen sin almacenar datos personales.

#### Scenario: Cambio aceptado
- **WHEN** la persona confirma el cambio de shell y Zsh está disponible
- **THEN** el sistema ejecuta el cambio para el usuario actual e informa de que surtirá efecto en la siguiente sesión

#### Scenario: Cambio rechazado
- **WHEN** la persona rechaza el cambio de shell
- **THEN** el bootstrap continúa correctamente y mantiene la shell predeterminada actual
