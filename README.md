# Dotfiles Fedora

Bootstrap personal reproducible para Fedora Workstation con GNOME.

## Instalación

En una instalación nueva, ejecuta:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rdiezsj/dotfiles/main/bootstrap)"
```

El instalador muestra un plan, solicita confirmación antes de cambiar el equipo y clona el repositorio en `~/.dotfiles` solo después de validar Fedora Workstation con GNOME. La validación se muestra una vez, al arrancar desde el clon compatible.

Tras instalar las dependencias mínimas, el bootstrap emplea Gum para distinguir las fases y el resumen final. Si Gum no está disponible todavía o se ejecuta con `DOTFILES_DISABLE_GUM=true`, conserva una salida ASCII legible. Un fallo de un elemento del catálogo no impide procesar los restantes; queda reflejado en el resumen y el comando termina con error.

Durante esta fase se instalan Homebrew y el grupo DNF `development-tools`. El bootstrap activa Homebrew en la shell actual y añade un bloque delimitado, idempotente y no destructivo a `~/.bashrc` y `~/.zshrc`. No cambia todavía la shell predeterminada con `chsh`.

## Catálogo base de software

Tras validar fuentes, el bootstrap instala el catálogo Fedora desde DNF, Flathub y AppImage. Incluye VS Code desde el repositorio oficial de Microsoft, Firefox desde DNF, Firefox PWA desde su repositorio oficial, ONLYOFFICE desde Flathub, multimedia RPM Fusion y soporte DVD. Elimina únicamente las variantes declaradas que entran en conflicto: Firefox Snap/Flatpak, LibreOffice y FreeOffice.

Heynote y Nextcloud Desktop se descargan en `~/Apps` con versión y SHA-256 fijados. Si ya hay un archivo distinto en una de esas rutas, se conserva y el resumen informa del conflicto. Cuando un AppImage queda verificado, el resumen indica su ruta para importarlo manualmente en Gear Lever.

Si el inventario PCI detecta NVIDIA, se instalan los controladores RPM Fusion y bibliotecas VA-API de 64 y 32 bits. Con Secure Boot activo, el bootstrap no desactiva ninguna protección: deja pendiente el enrolamiento MOK y el reinicio. Ver [verificación posterior](docs/catalogo-fedora.md).

Las fórmulas Homebrew de Zsh, Starship, fzf, Helm, kubectl, kubectx y tldr continúan fuera de alcance. Tampoco se versionan todavía ajustes de Terminator, input-remapper, Heynote, Gear Lever o Flameshot; se tratarán en un cambio dedicado, sin copiar configuraciones específicas de un equipo.

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
