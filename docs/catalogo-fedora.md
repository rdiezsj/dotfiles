# Catálogo base de Fedora

El bootstrap declara los paquetes por su gestor para que el origen y la actualización sean trazables:

- DNF/RPM: paquetes de Fedora, VS Code desde Microsoft y Firefox PWA desde un RPM oficial de GitHub Releases verificado.
- Flatpak: aplicaciones de escritorio por usuario desde Flathub.
- AppImage: Heynote 2.9.1 y Nextcloud Desktop 34.0.4 en `~/Apps`, con SHA-256 fijado.

Los catálogos están en `catalogs/dnf-rpm.sh`, `catalogs/firefoxpwa.sh`, `catalogs/flatpak.sh` y `catalogs/appimage.sh`. No contienen datos personales ni secretos.

## Orígenes validados

- [VS Code para Linux](https://code.visualstudio.com/docs/setup/linux): repositorio RPM oficial de Microsoft.
- [PWAsForFirefox](https://github.com/filips123/PWAsForFirefox/releases): release oficial de GitHub; el catálogo fija la versión y SHA-256 del RPM x86_64. Para actualizarlo se revisa una nueva release y se modifica ese catálogo.
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

Comprueba la instalación de Firefox PWA desde el RPM verificado:

```bash
rpm -q firefoxpwa
```

La versión mostrada debe coincidir con la declarada en `catalogs/firefoxpwa.sh`. En Fedora x86_64, una segunda ejecución del bootstrap debe informarla como ya presente.

Comprueba la variante completa de FFmpeg y los codecs:

```bash
ffmpeg -version
rpm -q ffmpeg libavcodec-freeworld libdvdcss
```

## Alcance aplazado

Zsh, Starship, plugins y las fórmulas Homebrew relacionadas quedan para el siguiente cambio. También quedan aplazados los ajustes versionables de Terminator, input-remapper, Heynote, Gear Lever y Flameshot: no se copian configuraciones desde un equipo existente.

## Validación dependiente de Fedora real

La suite automatizada usa dobles y no modifica el equipo de desarrollo. Antes de usar este catálogo en un equipo personal, ejecútalo en una VM Fedora 44 sin NVIDIA y, si hay hardware NVIDIA disponible, completa también la validación posterior al reinicio descrita arriba.
