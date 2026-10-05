# Dotfiles Fedora

Bootstrap personal reproducible para Fedora Workstation con GNOME.

## Instalación

En una instalación nueva, ejecuta:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rdiezsj/dotfiles/main/bootstrap)"
```

El instalador muestra un plan, solicita confirmación antes de cambiar el equipo y clona el repositorio en `~/.dotfiles` solo después de validar Fedora Workstation con GNOME. La validación se muestra una vez, al arrancar desde el clon compatible.

Tras instalar las dependencias mínimas, el bootstrap emplea Gum para distinguir las fases y el resumen final. Si Gum no está disponible todavía o se ejecuta con `DOTFILES_DISABLE_GUM=true`, conserva una salida ASCII legible. Un fallo de un elemento del catálogo no impide procesar los restantes; queda reflejado en el resumen y el comando termina con error.

Durante esta fase se instalan Homebrew y el grupo DNF `development-tools`. El bootstrap activa Homebrew en la shell actual y añade un bloque delimitado, idempotente y no destructivo a `~/.bashrc`. Zsh carga Homebrew desde los archivos versionados, que se enlazan mediante Dotbot con respaldo fechado de cualquier destino no gestionado. El cambio de shell predeterminada con `chsh` se ofrece después mediante una confirmación independiente.

## Catálogo base de software

Tras validar fuentes, el bootstrap instala el catálogo Fedora desde DNF, Homebrew, Flathub y AppImage. Incluye VS Code desde el repositorio oficial de Microsoft, Firefox desde DNF, Firefox PWA, Starship, Sheldon, fzf, Helm, `kubernetes-cli` y kubectx desde Homebrew, ONLYOFFICE desde Flathub, multimedia RPM Fusion y soporte DVD. Elimina únicamente las variantes declaradas que entran en conflicto: Firefox Snap/Flatpak, LibreOffice y FreeOffice.

Heynote y Nextcloud Desktop se descargan en `~/Apps` con versión y SHA-256 fijados. Si ya hay un archivo distinto en una de esas rutas, se conserva y el resumen informa del conflicto. Cuando un AppImage queda verificado, el resumen indica su ruta para importarlo manualmente en Gear Lever.

Si el inventario PCI detecta NVIDIA, se instalan los controladores RPM Fusion y bibliotecas VA-API de 64 y 32 bits. Con Secure Boot activo, el bootstrap no desactiva ninguna protección: deja pendiente el enrolamiento MOK y el reinicio. Ver [verificación posterior](docs/catalogo-fedora.md).

La configuración Zsh versionada carga Starship, fzf y los plugins declarados por Sheldon: completions, autosuggestions, autopair, resaltado de sintaxis, `sudo` y `extract`. `plugins.toml` contiene SHA fijados; los clones, lockfiles y demás caché de Sheldon se mantienen exclusivamente en `~/.local/share/sheldon/` y no se versionan. Tras el bootstrap, abre una sesión Zsh nueva y verifica `starship --version`, `sheldon --version`, `fzf --version`, `helm version --short` y `kubectl version --client`.

Para actualizar un plugin, revisa primero la nueva revisión Git, reemplaza exclusivamente su SHA en `~/.config/sheldon/plugins.toml` desde el repositorio y revisa el diff. Después materializa de forma explícita el estado local y reinicia Zsh:

```bash
sheldon --non-interactive --profile base lock
sheldon --non-interactive --profile resaltado lock
exec zsh
```

No ejecutes `sheldon lock --update` desde el arranque de Zsh ni como parte de una actualización rutinaria del bootstrap.

Zsh incluye también dos utilidades de archivos. `extract archivo.tar.gz` extrae tar, ZIP o 7z en un directorio homónimo sin borrar el original. `compress carpeta` abre un asistente Gum para elegir formato (`tar.gz`, `tar.xz`, ZIP o 7z), nivel, destino y división opcional en bloques. Si se generan partes, recompón el archivo antes de extraerlo:

```bash
cat archivo.tar.xz.part-* > archivo.tar.xz
extract archivo.tar.xz
```

Para revisar el plan sin cambiar nada desde el checkout:

```bash
cd ~/.dotfiles
./bootstrap --dry-run
```

Bitwarden CLI se instala mediante Homebrew. Para configurar Vaultwarden:

```bash
./bootstrap --vault-server https://tu-servidor
```

## Compatibilidad

`main` soporta únicamente la versión Fedora actual. Si una versión antigua ya no es compatible, el bootstrap no modifica el checkout e indica la etiqueta histórica correspondiente, por ejemplo `fedora-44`.

## Seguridad

El repositorio no contiene secretos, credenciales ni sesiones. Consulta [la guía de Vaultwarden](docs/vaultwarden.md) para la configuración y revocación de la sesión almacenada en GNOME Keyring.
