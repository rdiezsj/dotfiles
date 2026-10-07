# Spec Delta

## MODIFIED Requirements

### Requirement: Herramientas interactivas de la terminal
El sistema SHALL inicializar Homebrew, historial, alias, Starship,
`zsh-completions` y fzf desde los archivos de inicio correspondientes, sin
emitir salida ni modificar PATH en sesiones Zsh no interactivas. Al finalizar
el bootstrap, SHALL ofrecer una nueva sesión Zsh solo cuando la terminal que lo
invocó no sea Zsh.

#### Scenario: Nueva sesión interactiva
- **WHEN** se abre una sesión Zsh interactiva tras instalar las fórmulas declaradas
- **THEN** están disponibles el prompt Starship, el completado y los atajos de fzf

#### Scenario: Ejecución no interactiva
- **WHEN** Zsh ejecuta un comando no interactivo
- **THEN** la configuración no imprime elementos visuales ni bloquea la ejecución

#### Scenario: Bootstrap lanzado desde Zsh
- **WHEN** el bootstrap finaliza y la terminal que lo inició ya es Zsh
- **THEN** no solicita ni abre una sesión Zsh adicional y comunica que conserva la sesión actual

#### Scenario: Bootstrap lanzado desde otra shell
- **WHEN** el bootstrap finaliza y la terminal que lo inició no es Zsh
- **THEN** mantiene la solicitud existente para abrir una sesión Zsh nueva
