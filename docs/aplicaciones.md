# Configuración de aplicaciones

Dotbot enlaza solo los archivos declarados en el repositorio y no usa `force` ni
`relink`. Si encuentra un destino local no gestionado, muestra claramente el
destino que se sobrescribirá y el origen versionado para poder compararlos.
Solicita confirmación para cada conflicto antes de mover nada. Al aceptar todos,
guarda las copias locales en `~/.dotfiles-backups/dotbot-<fecha>/` y aplica los
enlaces; rechazar uno conserva todos los originales y cancela esta fase.

## Configuración versionada

| Aplicación o área | Destino enlazado | Nota |
| --- | --- | --- |
| Nano | `~/.nanorc` | Números de línea y sangrado; el ancho de tabulación queda comentado. |
| Vim | `~/.vimrc` | Números de línea y sangrado; el ancho de tabulación queda comentado. |
| Git | `~/.gitconfig`, `~/.gitignore` | No contiene credenciales. |
| Terminator | `~/.config/terminator/config` | Solo preferencias de terminal. |
| Flameshot | `~/.config/flameshot/flameshot.ini` | No fija directorio de capturas. |
| Heynote | `~/.config/Heynote/config.json`, `~/.config/Heynote/Preferences` | Las notas, buffers, sesiones y cachés siguen locales. |
| Input Remapper | `~/.config/input-remapper-2/config.json` | Parte con `autoload` vacío; el preset se crea y asocia manualmente al dispositivo real. |
| msmtp | `~/.config/msmtp/config` | La cuenta no contiene usuario, contraseña ni sesión; los consulta bajo demanda en Vaultwarden. |

## Datos locales deliberadamente excluidos

No se enlazan ni versionan perfiles de navegador, bibliotecas y documentos de
ONLYOFFICE, bóvedas de Bitwarden, notas de Obsidian, sesiones de Telegram,
Spotify o Steam, ni el sandbox, inventario, rutas o actualizaciones de Gear
Lever. Son datos del usuario o estado propio de cada equipo.

Los clones y lockfiles de Sheldon permanecen en `~/.local/share/sheldon/`.
El registro de msmtp se crea bajo `~/.local/state/msmtp/msmtp.log`; no se debe
editar el enlace de msmtp para guardar secretos.

## Correo con msmtp

Después de configurar Vaultwarden, `msmtp` consulta el ítem `Mail.ionos.es`
para obtener usuario y contraseña solo al enviar. Si la bóveda está bloqueada o
no hay sesión válida, el envío falla sin exponer valores y el bootstrap sigue
siendo correcto. Sigue la [guía de Vaultwarden](vaultwarden.md) para crear o
revocar la sesión.
