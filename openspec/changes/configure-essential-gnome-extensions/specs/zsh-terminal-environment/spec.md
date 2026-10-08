# Spec Delta

## MODIFIED Requirements

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
