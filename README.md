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

## Guías

- [Instalación y verificación](docs/instalacion.md)
- [Catálogo de software](docs/catalogo-fedora.md)
- [Configuración de aplicaciones](docs/aplicaciones.md)
- [Terminal y Zsh](docs/terminal.md)
- [Vaultwarden y GNOME Keyring](docs/vaultwarden.md)

## Construir el sitio de documentación

Instala las dependencias en un entorno aislado y construye el sitio con enlaces
estrictos:

```bash
python3 -m venv /tmp/dotfiles-docs
/tmp/dotfiles-docs/bin/pip install -r requirements-docs.txt
/tmp/dotfiles-docs/bin/mkdocs build --strict
```

El flujo de GitHub Actions repite esa construcción al cambiar documentación en
`main` o cuando se ejecuta manualmente. Tras integrarlo, una persona debe abrir
la configuración de Pages del repositorio y seleccionar **GitHub Actions** como
origen; la primera publicación se confirma desde la ejecución del flujo.

## Compatibilidad

`main` soporta únicamente la versión Fedora actual. Si una versión antigua ya no es compatible, el bootstrap no modifica el checkout e indica la etiqueta histórica correspondiente, por ejemplo `fedora-44`.

## Seguridad

El repositorio no contiene secretos, credenciales ni sesiones. Consulta [la guía de Vaultwarden](docs/vaultwarden.md) para la configuración y revocación de la sesión almacenada en GNOME Keyring.
