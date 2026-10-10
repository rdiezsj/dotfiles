# Vaultwarden y GNOME Keyring

El bootstrap instala Bitwarden CLI mediante Homebrew antes de solicitar la URL de Vaultwarden. Ejecuta `./bootstrap --vault-server https://tu-servidor` para configurar el servidor e iniciar sesión con `bw`. La contraseña maestra se solicita únicamente mediante la interfaz de Bitwarden CLI. Omitir la URL no revierte ni bloquea el bootstrap base.

El bootstrap guarda solo la sesión revocable `BW_SESSION` en GNOME Keyring. No guarda ni versiona la contraseña maestra, tokens ni credenciales.

Cada terminal interactiva Zsh recupera la sesión del llavero al ejecutar `bw`
y se la pasa únicamente a ese proceso. Bitwarden valida la sesión al ejecutar
el comando solicitado. El arranque de la terminal no accede al llavero ni lanza
Bitwarden; una sesión ausente o inválida no retrasa el prompt. Si ya has exportado
`BW_SESSION`, se respeta esa sesión sin consultar el llavero.
La recuperación requiere que GNOME Keyring esté disponible y desbloqueado.

Al repetir el bootstrap, una sesión válida existente evita volver a solicitar
la URL, iniciar sesión o desbloquear. Una URL explícita distinta mediante
`--vault-server` mantiene la configuración del nuevo servidor.

Después de desplegar esta corrección, abre una terminal Zsh nueva y ejecuta
`bw status`: debe indicar `unlocked`. No es necesario repetir el bootstrap si
la sesión guardada sigue siendo válida.

Para revocar la sesión, ejecuta `bw lock` y elimina la entrada `Sesión de Vaultwarden para dotfiles` desde Contraseñas y claves de GNOME.
