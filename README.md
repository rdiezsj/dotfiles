# Dotfiles Fedora

Bootstrap personal reproducible para Fedora Workstation con GNOME.

## Instalación

En una instalación nueva, ejecuta:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rdiezsj/dotfiles/main/bootstrap)"
```

El instalador muestra un plan, solicita confirmación antes de cambiar el equipo y clona el repositorio en `~/.dotfiles` solo después de validar Fedora Workstation con GNOME. La validación se muestra una vez, al arrancar desde el clon compatible.

Durante esta fase se instalan Homebrew y el grupo DNF `development-tools`. El bootstrap activa Homebrew en la shell actual y añade un bloque delimitado, idempotente y no destructivo a `~/.bashrc` y `~/.zshrc`. No cambia todavía la shell predeterminada con `chsh`.

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
