# Catálogo base de Fedora

El bootstrap declara los paquetes por su gestor para que el origen y la actualización sean trazables:

- DNF/RPM: paquetes de Fedora y VS Code desde Microsoft.
- Homebrew: Firefox PWA, Starship, Sheldon, fzf, Helm, `kubernetes-cli` y kubectx.
- Flatpak: aplicaciones de escritorio por usuario desde Flathub.
- AppImage: Heynote 2.9.1 y Nextcloud Desktop 34.0.4 en `~/Apps`, con SHA-256 fijado.

Los catálogos están en `catalogs/dnf-rpm.sh`, `catalogs/homebrew.sh`, `catalogs/flatpak.sh` y `catalogs/appimage.sh`. No contienen datos personales ni secretos.

## Orígenes validados

- [VS Code para Linux](https://code.visualstudio.com/docs/setup/linux): repositorio RPM oficial de Microsoft.
- [Firefox PWA en Homebrew](https://formulae.brew.sh/formula/firefoxpwa): fórmula instalada por Homebrew y actualizada con sus mecanismos habituales.
- Herramientas de terminal: Starship, Sheldon, fzf, Helm, `kubernetes-cli` y kubectx se instalan como fórmulas Homebrew. Sheldon gestiona los plugins Zsh desde `~/.config/sheldon/plugins.toml`, con SHA fijados en el repositorio.
- [RPM Fusion](https://rpmfusion.org/): Free, Nonfree y Free tainted para multimedia y DVD.
- [Flathub](https://flathub.org/): remoto Flatpak por usuario.
- [Heynote 2.9.1](https://github.com/heyman/heynote/releases/tag/v2.9.1) y [descargas de Nextcloud Desktop](https://download.nextcloud.com/desktop/releases/Linux/): binarios AppImage fijados en el catálogo.

El bootstrap importa la clave oficial de Microsoft y declara el repositorio YUM específico de VS Code con `gpgcheck=1`. También comprueba que las URLs críticas coinciden con las declaradas. No acepta claves, repositorios ni sumas desde entradas proporcionadas en tiempo de ejecución.

## Sustituciones deliberadas

Para evitar duplicidades, se retiran exclusivamente Firefox de Snap o Flatpak y las variantes LibreOffice/FreeOffice de DNF o Flatpak. No se borran perfiles, documentos ni directorios de datos de usuario.

## Verificación tras reiniciar

Cuando se instala NVIDIA, reinicia antes de validar el controlador:

```bash
nvidia-smi
```

Si Secure Boot estaba activo, completa el enrolamiento MOK que solicita el sistema durante el reinicio y vuelve a ejecutar el comando anterior. El bootstrap no desactiva Secure Boot ni automatiza firmware.

Comprueba el servicio de Syncthing para el usuario actual:

```bash
systemctl --user status syncthing.service
```

Es un servicio de usuario, no un demonio global ejecutado como `root`; por ello usa el HOME y los permisos de quien ejecutó el bootstrap. Se inicia con la sesión gráfica. Si se requiere que continúe sin iniciar sesión, habilita explícitamente `linger` más adelante.

Comprueba la instalación de Firefox PWA desde Homebrew:

```bash
brew list --versions firefoxpwa
```

Comprueba las herramientas de terminal instaladas por Homebrew:

```bash
brew list --versions starship sheldon fzf helm kubernetes-cli kubectx
```

En una segunda ejecución del bootstrap, la fórmula debe informarse como ya presente.

## Plugins Zsh y utilidades de archivos

El bootstrap enlaza `~/.config/sheldon/plugins.toml` mediante Dotbot y materializa las revisiones SHA declaradas. No enlaza ni versiona `~/.local/share/sheldon/`: contiene clones y lockfiles con rutas del equipo. Para volver a materializar los perfiles tras modificar una SHA revisada:

```bash
sheldon --non-interactive --profile base lock
sheldon --non-interactive --profile resaltado lock
```

Los plugins incluyen autosuggestions, autopair, resaltado de sintaxis, completions, `sudo` con doble Escape y `extract`. Usa `compress <archivo-o-carpeta>` para crear `tar.gz`, `tar.xz`, ZIP o 7z mediante un asistente Gum. La división por bloques conserva los originales y muestra el comando de recomposición. Por ejemplo:

```bash
cat respaldo.tar.xz.part-* > respaldo.tar.xz
extract respaldo.tar.xz
```

Zsh define `DOTFILES=~/.dotfiles` y añade solo si existen `~/.local/bin`, `~/.dotfiles/bin` y `~/.krew/bin`, eliminando duplicados mediante `typeset -U`. Las rutas de Homebrew las configura `brew shellenv`; no se añaden rutas de macOS ni rutas adicionales de fzf. El historial de fzf usa modo Emacs con `--height 40% --layout=reverse --border`, y `kubectl completion zsh` se carga después de `compinit`.

Comprueba la variante completa de FFmpeg y los codecs:

```bash
ffmpeg -version
rpm -q ffmpeg libavcodec-freeworld libdvdcss
```

## Configuración versionada de aplicaciones

El bootstrap enlaza los siguientes archivos cuando no existe una configuración
local no gestionada:

- `~/.nanorc`, `~/.vimrc`, `~/.gitconfig` y `~/.gitignore`.
- `~/.config/terminator/config` y `~/.config/flameshot/flameshot.ini`.
- `~/.config/Heynote/config.json` y `~/.config/Heynote/Preferences`.
- `~/.config/input-remapper-2/config.json`.
- `~/.config/msmtp/config`.

Nano y Vim muestran números de línea, sangrado y tabulaciones como espacios,
pero dejan el tamaño de tabulación comentado hasta decidir si será de 2 o 4.
Flameshot no fija un directorio de guardado. Edita los comentarios de sus
ficheros versionados y vuelve a ejecutar el bootstrap para aplicar esos valores
en otro equipo.

Input Remapper 2 parte de un `autoload` vacío. Tras crear un preset para el
dispositivo real, asígnalo explícitamente desde la interfaz de la aplicación.
El bootstrap habilita `input-remapper.service`, pero no activa ningún remapeo
por sí mismo.

`msmtp` se instala por DNF y recibe la cuenta IONOS versionada en
`~/.config/msmtp/config`, sin usuario, contraseña ni sesión. Al enviar, los
helpers `~/.dotfiles/bin/msmtp-obtener-usuario` y
`~/.dotfiles/bin/msmtp-obtener-contrasena` consultan bajo demanda el ítem
`Mail.ionos.es` mediante la sesión almacenada en GNOME Keyring. El registro se
guarda en `~/.local/state/msmtp/msmtp.log` y se crea al primer envío.

Para habilitar el envío, configura y desbloquea Vaultwarden desde el bootstrap:

```bash
cd ~/.dotfiles
./bootstrap --vault-server https://tu-servidor
```

Si no hay sesión válida, el envío falla sin exponer valores y el bootstrap
sigue siendo correcto. No edites el enlace `~/.config/msmtp/config` para
guardar secretos.

Gear Lever conserva como referencia `templates/gearlever/config.template`. No
se enlaza su sandbox Flatpak ni se versionan los AppImages importados, rutas,
inventario o estado de actualizaciones. Heynote también excluye notas, buffers,
sesiones y cachés: solo se versionan los dos ficheros indicados arriba.

## Validación dependiente de Fedora real

La suite automatizada usa dobles y no modifica el equipo de desarrollo. Antes de usar este catálogo en un equipo personal, ejecútalo en una VM Fedora 44 sin NVIDIA y, si hay hardware NVIDIA disponible, completa también la validación posterior al reinicio descrita arriba.
