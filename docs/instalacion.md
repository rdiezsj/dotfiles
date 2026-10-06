# Instalación y verificación

## Requisitos y alcance

El bootstrap solo continúa en Fedora Workstation con GNOME y con una referencia
compatible. Desde el instalador remoto, el repositorio se clona en
`~/.dotfiles` únicamente tras esa validación. No sustituye archivos locales no
gestionados por Dotbot ni solicita datos personales durante la instalación.

## Ejecutar el bootstrap

En una instalación nueva:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rdiezsj/dotfiles/main/bootstrap)"
```

En un checkout existente, revisa primero el plan sin efectuar cambios:

```bash
cd ~/.dotfiles
./bootstrap --dry-run
```

La ejecución real vuelve a solicitar confirmación antes de instalar paquetes,
crear el scaffold personal o enlazar configuración. Un fallo de una aplicación
del catálogo se registra en el resumen; el resto del catálogo sigue su curso.

## Fases

1. Dependencias mínimas y validación del entorno.
2. Fuentes RPM Fusion y Microsoft, Homebrew y herramientas de compilación.
3. Carpetas personales, plantillas de Nautilus y catálogo de software.
4. Configuración versionada, servicio Input Remapper, multimedia y NVIDIA.
5. Bitwarden CLI y la configuración opcional de Vaultwarden.

Consulta [Catálogo de software](catalogo-fedora.md) para el detalle de cada
paquete y [Configuración de aplicaciones](aplicaciones.md) para los enlaces.

## Verificación posterior

Abre una sesión Zsh nueva tras finalizar y comprueba las herramientas de
terminal descritas en [Terminal y Zsh](terminal.md). Si se detectó NVIDIA,
reinicia antes de ejecutar:

```bash
nvidia-smi
```

Con Secure Boot activo, completa antes el enrolamiento MOK solicitado por el
sistema. El bootstrap no desactiva Secure Boot ni automatiza firmware.

Comprueba también el servicio de Syncthing para el usuario actual:

```bash
systemctl --user status syncthing.service
```

Los AppImages descargados en `~/Apps` requieren importación manual en Gear
Lever. Los presets reales de Input Remapper se asocian manualmente al
dispositivo después de identificarlo.
