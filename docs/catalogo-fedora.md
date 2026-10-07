# Catálogo de software

El bootstrap declara el software por gestor en `catalogs/`. Esta guía es la
referencia operativa: indica finalidad y, cuando existe, la configuración
versionada. «Local» significa que no se enlaza ni se versiona.

## DNF/RPM

Además de los paquetes de Fedora, este grupo instala VS Code desde el
repositorio oficial de Microsoft. Firefox se gestiona desde DNF.

| Aplicación | Finalidad | Configuración |
| --- | --- | --- |
| GNOME Tweaks | Ajustes adicionales de GNOME. | Local. |
| Sushi | Vista previa rápida en Nautilus. | Local. |
| p7zip y complementos | Crear y extraer archivos 7z. | Local. |
| zip y unzip | Crear y extraer ZIP. | Local. |
| File Roller | Interfaz gráfica de archivos comprimidos. | Local. |
| VLC | Reproducción multimedia. | Local. |
| Syncthing | Sincronización entre dispositivos; habilita su servicio de usuario. | Local. |
| Terminator | Terminal gráfica. | Versionada: `~/.config/terminator/config`. |
| Nano | Editor de texto. | Versionada: `~/.nanorc`. |
| Vim | Editor de texto. | Versionada: `~/.vimrc`. |
| wl-clipboard | Portapapeles para Wayland. | Local. |
| pipx | Instalación aislada de aplicaciones Python. | Local. |
| Input Remapper | Remapeo de dispositivos; habilita su servicio de sistema. | Versionado: directorio completo `~/.config/input-remapper-2/`, incluido el perfil asociado a Logitech MX Master 3. |
| fuse-libs | Biblioteca FUSE v2 para ejecutar AppImage v2. | Local. |
| msmtp | Cliente SMTP compatible con sendmail. | Versionada sin secretos: `~/.config/msmtp/config`. |
| Flameshot | Capturas de pantalla. | Versionada: `~/.config/flameshot/flameshot.ini`. |
| Visual Studio Code | Editor y entorno de desarrollo. | Local. |
| Firefox | Navegador web. | Perfil y datos, locales. |
| ChatGPT | Aplicación de escritorio con Codex; RPM oficial de OpenAI. | Cuenta, conversaciones y estado de la aplicación, locales. |

RPM Fusion añade el soporte multimedia `ffmpeg`, `libavcodec-freeworld` y,
cuando está disponible el repositorio tainted, `libdvdcss`. Si el inventario
PCI detecta NVIDIA, instala además `akmod-nvidia`, CUDA, VA-API y bibliotecas
de 32 bits; son componentes condicionales, no aplicaciones configuradas por
Dotbot. El bootstrap comprueba paquetes, akmods, el módulo del kernel activo y
el controlador; con Secure Boot puede requerir el enrolamiento MOK.

El bootstrap también instala las dependencias técnicas `git`, `curl`, `zsh`,
`flatpak`, `gum`, `python3`, `libsecret`, `pciutils` y `mokutil`, junto al grupo
DNF `development-tools`. Son soporte del proceso; sus datos específicos de
usuario no se versionan, salvo las configuraciones de Git y Zsh documentadas
en [Aplicaciones](aplicaciones.md) y [Terminal](terminal.md).

## Homebrew

Homebrew se instala antes de este catálogo. Bitwarden CLI se instala al final
del bootstrap si aún no está disponible, para la configuración opcional de
Vaultwarden.

| Aplicación | Finalidad | Configuración |
| --- | --- | --- |
| Firefox PWA | Crear y ejecutar aplicaciones web de Firefox. | Local. |
| Starship | Prompt de shell. | Versionada: `~/.config/starship.toml`. |
| Sheldon | Gestor de plugins Zsh. | Versionada: `~/.config/sheldon/plugins.toml`; clones y lockfiles, locales. |
| fzf | Búsqueda interactiva en terminal. | Ajustes en Zsh versionada; caché local. |
| Helm | Gestor de paquetes Kubernetes. | Repositorios y estado, locales. |
| kubernetes-cli | Cliente `kubectl`. | Configuración de clúster, local; solo su completado se carga desde Zsh. |
| kubectx | Cambio rápido de contexto Kubernetes. | Contextos, locales. |
| OpenSpec | CLI global para desarrollo guiado por especificaciones. | Instalación global Homebrew; no se declara como dependencia de cada proyecto. Verificar con `openspec --version`. |
| Bitwarden CLI | Acceso a Vaultwarden desde terminal. | Sesión revocable en GNOME Keyring, nunca en el repositorio. |

## Flatpak (Flathub por usuario)

| Aplicación | Finalidad | Configuración |
| --- | --- | --- |
| ONLYOFFICE | Suite ofimática. | Documentos, preferencias y sandbox, locales. |
| Bitwarden | Aplicación de escritorio de Bitwarden. | Bóveda y sesión, locales. |
| Obsidian | Gestión de conocimiento. | Bóvedas, plugins y preferencias, locales. |
| NotepadNext | Editor de texto. | Local. |
| Telegram | Mensajería. | Sesión y datos, locales. |
| Spotify | Música. | Sesión y caché, locales. |
| Ark | Gestor de archivos comprimidos. | Local. |
| Meld | Comparación de archivos. | Local. |
| Steam | Juegos. | Biblioteca, sesión y datos, locales. |
| Emote | Selector de emoji. | Local. |
| Gear Lever | Gestión de AppImages. | Versionada: carpeta predeterminada `~/Apps`; sandbox, inventario, rutas por aplicación y actualizaciones, locales. |
| LocalSend | Transferencia local de archivos. | Dispositivos y preferencias, locales. |
| GNOME Extensions | Gestión de extensiones de GNOME Shell. | Extensiones instaladas y preferencias, locales. |

## AppImage verificados

Los binarios se descargan en `~/Apps` con versión y SHA-256 fijados. Si ya hay
un archivo distinto en la misma ruta, se conserva y el resumen informa del
conflicto. Tras verificarlos, Gear Lever debe importarlos manualmente y usa
esa misma carpeta como ubicación predeterminada. `fuse-libs` aporta
`libfuse.so.2`, necesaria para ejecutar AppImage v2.

| Aplicación | Versión | Finalidad | Configuración |
| --- | --- | --- | --- |
| Heynote | 2.9.1 | Bloc de notas temporal para desarrollo. | Versionada: `~/.config/Heynote/config.json` y `Preferences`; notas, buffers y cachés, locales. |
| Nextcloud Desktop | 34.0.4 | Sincronización con Nextcloud. | Cuenta, carpetas y estado, locales. |

## Orígenes validados

- [VS Code para Linux](https://code.visualstudio.com/docs/setup/linux): repositorio RPM oficial de Microsoft.
- [ChatGPT para Linux](https://learn.chatgpt.com/docs/linux/linux-app): Fedora 43/44 con RPM x86_64 o aarch64; DNF configura el repositorio firmado oficial para actualizaciones. Abrir con `chatgpt` o desde el menú de aplicaciones.
- [Firefox PWA en Homebrew](https://formulae.brew.sh/formula/firefoxpwa): fórmula instalada por Homebrew y actualizada con sus mecanismos habituales.
- [OpenSpec en Homebrew](https://formulae.brew.sh/formula/openspec): CLI global instalada como fórmula solo cuando no existe ya un comando global funcional; comprobar con `openspec --version`.
- Herramientas de terminal: Starship, Sheldon, fzf, Helm, `kubernetes-cli`, kubectx y OpenSpec se instalan como fórmulas Homebrew. Sheldon gestiona los plugins Zsh desde `~/.config/sheldon/plugins.toml`, con SHA fijados en el repositorio.
- [RPM Fusion](https://rpmfusion.org/): Free, Nonfree y Free tainted para multimedia y DVD.
- [Flathub](https://flathub.org/): remoto Flatpak por usuario.
- [Heynote 2.9.1](https://github.com/heyman/heynote/releases/tag/v2.9.1) y [descargas de Nextcloud Desktop](https://download.nextcloud.com/desktop/releases/Linux/): binarios AppImage fijados en el catálogo.

El bootstrap importa la clave oficial de Microsoft y declara el repositorio YUM específico de VS Code con `gpgcheck=1`. También comprueba que las URLs críticas coinciden con las declaradas. No acepta claves, repositorios ni sumas desde entradas proporcionadas en tiempo de ejecución.

## Sustituciones deliberadas

Para evitar duplicidades, se retiran exclusivamente Firefox de Snap o Flatpak y las variantes LibreOffice/FreeOffice de DNF o Flatpak. No se borran perfiles, documentos ni directorios de datos de usuario.

## Reinicio y validación NVIDIA

El bootstrap valida automáticamente el controlador NVIDIA mientras se ejecuta.
Si el resumen final indica que falta reiniciar, reinicia manualmente y vuelve a
ejecutar manualmente el bootstrap desde el checkout:

```bash
cd ~/.dotfiles
./bootstrap
```

No es necesario ejecutar `nvidia-smi` manualmente: la segunda ejecución lo
comprueba junto con los paquetes, akmods y el módulo del kernel activo. Si
Secure Boot estaba activo, completa primero el enrolamiento MOK solicitado
durante el reinicio. El bootstrap no desactiva Secure Boot, no automatiza
firmware ni reinicia el equipo por su cuenta.

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

## Validación dependiente de Fedora real

La suite automatizada usa dobles y no modifica el equipo de desarrollo. Antes
de usar este catálogo en un equipo personal, ejecútalo en una VM Fedora 44 sin
NVIDIA y, si hay hardware NVIDIA disponible, completa también la validación
posterior al reinicio reejecutando manualmente el bootstrap como se describe
arriba.
