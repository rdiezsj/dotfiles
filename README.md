# Dotfiles Fedora

Bootstrap personal reproducible para Fedora Workstation con GNOME.

## Documentación en línea

Consulta la documentación publicada en [rdiezsj.github.io/dotfiles](https://rdiezsj.github.io/dotfiles/).

## Instalación

En una instalación nueva, ejecuta:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rdiezsj/dotfiles/main/bootstrap)"
```

El instalador muestra un plan, solicita confirmación antes de cambiar el equipo y clona el repositorio en `~/.dotfiles` solo después de validar Fedora Workstation con GNOME. La validación se muestra una vez, al arrancar desde el clon compatible.

Tras instalar las dependencias mínimas, el bootstrap emplea Gum para distinguir las fases y el resumen final. Si Gum no está disponible todavía o se ejecuta con `DOTFILES_DISABLE_GUM=true`, conserva una salida ASCII legible. Un fallo de un elemento del catálogo no impide procesar los restantes; queda reflejado en el resumen y el comando termina con error.

Cuando detecta una GPU NVIDIA compatible, el bootstrap verifica automáticamente
la pila propietaria de RPM Fusion, akmods, el módulo del kernel activo y
`nvidia-smi`. Si el resumen final indica que necesita reiniciar, la persona debe
reiniciar manualmente y volver a ejecutar manualmente `./bootstrap` desde
`~/.dotfiles`; el bootstrap no reinicia ni se reejecuta por su cuenta. Con
Secure Boot, completa primero el enrolamiento MOK durante el reinicio.

Durante esta fase se instalan Homebrew y el grupo DNF `development-tools`. El bootstrap activa Homebrew en la shell actual y añade un bloque delimitado, idempotente y no destructivo a `~/.bashrc`. Antes de que Dotbot enlace un destino local no gestionado, muestra el destino que se sobrescribirá y su dotfile versionado, y solicita confirmación explícita. Si se aceptan todos los conflictos, guarda copias fechadas en `~/.dotfiles-backups/dotbot-*`; rechazar uno cancela esa fase sin modificar archivos. El cambio de shell predeterminada con `chsh` se ofrece después mediante una confirmación independiente.

## Guías

- [Instalación y verificación](docs/instalacion.md)
- [Catálogo de software](docs/catalogo-fedora.md)
- [Configuración de aplicaciones](docs/aplicaciones.md)
- [Terminal y Zsh](docs/terminal.md)
- [Vaultwarden y GNOME Keyring](docs/vaultwarden.md)

## Hoja de ruta

Ideas pendientes para iterar sobre el entorno. No implican un cambio aprobado
ni se aplican automáticamente.

- Configuración de tema y apariencia para Zellij.
- Atajos de teclado.
- Scripts de actualización.
- Wiki de GitHub.
- Integración continua técnica: sintaxis Bash, pruebas unitarias y OpenSpec estricto.
- Escaneo local y en CI para prevenir secretos versionados.
- Diagnóstico de solo lectura `dotfiles doctor` para detectar deriva de configuración.
- Validación del bootstrap en una estación Fedora de destino para Ptyxis y Zellij.
- Actualización verificable de Nextcloud AppImage mediante su firma publicada.
- Teclas Inicio y Fin en el teclado.

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
