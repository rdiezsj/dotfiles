# Spec Delta

## MODIFIED Requirements

### Requirement: Configuraciones portables mediante Dotbot
El sistema SHALL enlazar las configuraciones versionadas de Nano, Vim, Git,
Terminator, Ptyxis, Zellij, Flameshot, Heynote, Input Remapper 2 y msmtp solo
cuando el destino esté ausente o ya sea el enlace gestionado. La configuración
de Ptyxis SHALL ser una exportación limitada de Dconf aplicable sin incluir la
base Dconf completa. La de Zellij SHALL enlazar su directorio XDG completo y
conservar sus atajos predeterminados.
Los destinos no gestionados SHALL seguir el mecanismo existente de detección de
conflictos y no serán reemplazados.

#### Scenario: Estación nueva sin configuraciones
- **WHEN** el bootstrap aplica Dotbot sobre una estación Fedora nueva
- **THEN** las configuraciones portables declaradas quedan disponibles en sus rutas de usuario XDG o de HOME

#### Scenario: Configuración local no gestionada
- **WHEN** existe un archivo de configuración distinto en un destino declarado
- **THEN** el bootstrap informa del conflicto y conserva el archivo local

#### Scenario: Perfil Ptyxis reproducible
- **WHEN** el bootstrap ha enlazado y aplicado la configuración de Ptyxis en una estación con Ptyxis instalado
- **THEN** Ptyxis usa un perfil Nord oscuro con scrollback sin límite sin modificar preferencias Dconf ajenas a `/org/gnome/Ptyxis/`

#### Scenario: Atajos nativos de Zellij
- **WHEN** se inicia Zellij con su configuración gestionada
- **THEN** `Ctrl+P` seguido de `D` o `R` conserva las divisiones predeterminadas y Zellij no se inicia automáticamente desde la shell

#### Scenario: Directorio Zellij extensible
- **WHEN** se añade una configuración o plugin versionado bajo `home/.config/zellij/`
- **THEN** queda disponible en `~/.config/zellij/` mediante el enlace Dotbot sin crear enlaces individuales adicionales
