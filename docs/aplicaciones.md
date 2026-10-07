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
| Terminator | `~/.config/terminator/config`, `~/.local/bin/terminator`, `~/.local/share/applications/terminator.desktop` | Preferencias de terminal y lanzadores que fuerzan `Adwaita:dark` solo para Terminator; cierra todas sus ventanas antes de abrirlo para aplicar el cambio. |
| Flameshot | `~/.config/flameshot/flameshot.ini` | Preferencias manuales versionadas, incluida la ruta de capturas y el arranque automático. |
| Heynote | `~/.config/Heynote/config.json`, `~/.config/Heynote/Preferences` | Se versionan exactamente esos ficheros manuales; los demás datos siguen locales. |
| Input Remapper | `~/.config/input-remapper-2/` | Configuración y presets completos, incluido Logitech MX Master 3. |
| msmtp | `~/.config/msmtp/config` | La cuenta no contiene usuario, contraseña ni sesión; los consulta bajo demanda en Vaultwarden. |
| Codex | `~/.codex/AGENTS.md`, `~/.codex/skills/<skill-propia>/` | Se versionan y enlazan las instrucciones y cada skill propia. Las skills predeterminadas de Codex (`.system/`) permanecen gestionadas por la aplicación y no se enlazan desde el repositorio. |

## Datos locales deliberadamente excluidos

No se enlazan ni versionan perfiles de navegador, bibliotecas y documentos de
ONLYOFFICE, bóvedas de Bitwarden, notas de Obsidian, sesiones de Telegram,
Spotify o Steam, ni el sandbox, inventario, rutas por aplicación o
actualizaciones de Gear Lever. Son datos del usuario o estado propio de cada
equipo.

Los clones y lockfiles de Sheldon permanecen en `~/.local/share/sheldon/`.
El registro de msmtp se crea bajo `~/.local/state/msmtp/msmtp.log`; no se debe
editar el enlace de msmtp para guardar secretos.

La autenticación, `~/.codex/config.toml`, conversaciones, cachés, plugins y
otros datos locales de Codex no se versionan ni se enlazan. ChatGPT Desktop
proporciona Codex en Fedora compatible; inicia sesión en la propia aplicación.

## Correo con msmtp

Después de configurar Vaultwarden, `msmtp` consulta el ítem `Mail.ionos.es`
para obtener usuario y contraseña solo al enviar. Si la bóveda está bloqueada o
no hay sesión válida, el envío falla sin exponer valores y el bootstrap sigue
siendo correcto. Sigue la [guía de Vaultwarden](vaultwarden.md) para crear o
revocar la sesión.
