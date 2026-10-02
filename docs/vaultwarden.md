# Vaultwarden y GNOME Keyring

El bootstrap instala Bitwarden CLI mediante Homebrew antes de solicitar la URL de Vaultwarden. Ejecuta `./bootstrap --vault-server https://tu-servidor` para configurar el servidor e iniciar sesión con `bw`. La contraseña maestra se solicita únicamente mediante la interfaz de Bitwarden CLI. Omitir la URL no revierte ni bloquea el bootstrap base.

El bootstrap guarda solo la sesión revocable `BW_SESSION` en GNOME Keyring. No guarda ni versiona la contraseña maestra, tokens ni credenciales.

Para revocar la sesión, ejecuta `bw lock` y elimina la entrada `Sesión de Vaultwarden para dotfiles` desde Contraseñas y claves de GNOME.
