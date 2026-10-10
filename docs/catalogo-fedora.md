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
| Terminator | Terminal gráfica alternativa. | Versionada: configuración, lanzador `~/.local/bin/terminator` y entrada de GNOME; usa `Adwaita:dark` solo para Terminator. |
| Ptyxis | Terminal principal de GNOME. | Versionada: perfil Nord mediante exportación Dconf limitada a Ptyxis. |
| Nano | Editor de texto. | Versionada: `~/.nanorc`. |
| Vim | Editor de texto. | Versionada: `~/.vimrc`. |
| wl-clipboard | Portapapeles para Wayland. | Local. |
| pipx | Instalación aislada de aplicaciones Python. | Local. |
| dconf | Herramienta de configuración para aplicaciones GNOME. | Local; aplica el perfil versionado de Ptyxis. |
| Input Remapper | Remapeo de dispositivos; habilita su servicio de sistema. | Versionado: directorio completo `~/.config/input-remapper-2/`, incluido el perfil asociado a Logitech MX Master 3. |
| fuse-libs | Biblioteca FUSE v2 para ejecutar AppImage v2. | Local. |
| AppIndicator | Indicadores de aplicaciones para GNOME Shell. | Activación local de la extensión; preferencias, locales. |
| Dash to Dock | Dock configurable para GNOME Shell. | Activación y preferencias, locales. |
| libgtop2-devel | Biblioteca de métricas del sistema requerida por Vitals. | Local. |
| lm_sensors | Lectura de sensores de hardware requerida por Vitals. | Local. |
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
| Firefox PWA | Crear y ejecutar aplicaciones web de Firefox. | El bootstrap enlaza el manifiesto nativo de Homebrew para Firefox; aplicaciones y datos, locales. |
| Starship | Prompt de shell. | Versionada: `~/.config/starship.toml`. |
| Sheldon | Gestor de plugins Zsh. | Versionada: `~/.config/sheldon/plugins.toml`; clones y lockfiles, locales. |
| fzf | Búsqueda interactiva en terminal. | Ajustes en Zsh versionada; caché local. |
| Helm | Gestor de paquetes Kubernetes. | Repositorios y estado, locales. |
| kubernetes-cli | Cliente `kubectl`. | Configuración de clúster, local; solo su completado se carga desde Zsh. |
| kubectx | Cambio rápido de contexto Kubernetes. | Contextos, locales. |
| Zellij | Multiplexor de terminal con paneles. | Versionado: directorio completo `~/.config/zellij/`, preparado para futuras extensiones; se inicia manualmente y conserva `Ctrl+P`, `D` y `R`. |
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

## Extensiones GNOME

Después del catálogo de software, el bootstrap instala y activa el conjunto
siguiente para la persona que lo ejecuta. AppIndicator y Dash to Dock usan los
paquetes oficiales de Fedora; las demás se descargan exclusivamente de
extensions.gnome.org tras comprobar una publicación compatible con la versión
de GNOME Shell. No se usan clones Git, COPR ni compilación local.

| Extensión | UUID | Origen | Dependencias y configuración |
| --- | --- | --- | --- |
| AppIndicator | `appindicatorsupport@rgcjonas.gmail.com` | DNF: `gnome-shell-extension-appindicator`. | Activación y preferencias, locales. |
| Custom Hot Corners Extended | `custom-hot-corners-extended@G-dH.github.com` | extensions.gnome.org. | Activación y preferencias, locales. |
| Clipboard Indicator | `clipboard-indicator@tudmotu.com` | extensions.gnome.org. | Activación y preferencias, locales. |
| Vitals | `Vitals@CoreCoding.com` | extensions.gnome.org. | Requiere `libgtop2-devel` y `lm_sensors`; activación y preferencias, locales. |
| Dash to Dock | `dash-to-dock@micxgx.gmail.com` | DNF: `gnome-shell-extension-dash-to-dock`. | Activación y preferencias, locales. |

El bloque no modifica extensiones ajenas ni preferencias. Si una extensión
queda pendiente al terminar el bootstrap, cierra e inicia sesión manualmente y
ejecuta `activar-extensiones-gnome`. Esa situación aparece en «Acciones
manuales pendientes», no en «Fallidos»; el comando solo activa y verifica las
extensiones declaradas, sin actualizar software ni modificar preferencias. El
bootstrap no reinicia la sesión ni el equipo.

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
- [Zellij en Homebrew](https://formulae.brew.sh/formula/zellij): multiplexor de terminal instalado como fórmula; se conserva su configuración y sus atajos nativos.
- Herramientas de terminal: Starship, Sheldon, fzf, Helm, `kubernetes-cli`, kubectx, Zellij y OpenSpec se instalan como fórmulas Homebrew. Sheldon gestiona los plugins Zsh desde `~/.config/sheldon/plugins.toml`, con SHA fijados en el repositorio.
- [RPM Fusion](https://rpmfusion.org/): Free, Nonfree y Free tainted para multimedia y DVD.
- [Flathub](https://flathub.org/): remoto Flatpak por usuario.
- [Extensiones GNOME](https://extensions.gnome.org/): origen de las publicaciones compatibles de Custom Hot Corners Extended, Clipboard Indicator y Vitals.
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

El bootstrap crea `/usr/lib/mozilla/native-messaging-hosts/firefoxpwa.json`
como enlace al manifiesto de la fórmula Homebrew y comprueba que el conector
declarado existe y es ejecutable. También realiza este paso si la fórmula ya
estaba instalada. Si encuentra un archivo o enlace distinto en el destino,
lo conserva y registra el conflicto para revisarlo antes de repetir el bootstrap.
La extensión Firefox PWA debe instalarse en el navegador; el enlace permite
que se comunique con el componente nativo. No se inicia ningún servicio Zellij:
su uso como multiplexor sigue siendo manual mediante `zellij`.

```bash
brew list --versions firefoxpwa
```

Comprueba las herramientas de terminal instaladas por Homebrew:

```bash
brew list --versions starship sheldon fzf helm kubernetes-cli kubectx zellij
```

En una segunda ejecución del bootstrap, la fórmula debe informarse como ya presente.

## Validación dependiente de Fedora real

La suite automatizada usa dobles y no modifica el equipo de desarrollo. Antes
de usar este catálogo en un equipo personal, ejecútalo en una VM Fedora 44 sin
NVIDIA y, si hay hardware NVIDIA disponible, completa también la validación
posterior al reinicio reejecutando manualmente el bootstrap como se describe
arriba.
