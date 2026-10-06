# Dotfiles Fedora

Bootstrap personal, reproducible y conservador para Fedora Workstation con
GNOME. Instala el catálogo aprobado, enlaza únicamente la configuración
versionada y conserva locales los datos personales, cachés, sesiones e
inventarios de aplicaciones.

## Recorrido recomendado

1. Lee [Instalación y verificación](instalacion.md) para confirmar el entorno,
   revisar la simulación y entender las confirmaciones.
2. Consulta el [catálogo de software](catalogo-fedora.md) antes de ejecutar el
   bootstrap: detalla todas las aplicaciones, su gestor y la configuración que
   queda versionada o local.
3. Tras instalar, configura lo que requiera decisión humana en
   [Configuración de aplicaciones](aplicaciones.md), [Terminal y Zsh](terminal.md)
   y [Vaultwarden](vaultwarden.md).

## Inicio rápido

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rdiezsj/dotfiles/main/bootstrap)"
```

El instalador presenta el plan y solicita confirmación antes de modificar el
equipo. Para inspeccionar un checkout existente sin cambios, ejecuta
`./bootstrap --dry-run` desde `~/.dotfiles`.

## Límites importantes

- `main` solo admite la versión Fedora actual; una versión legacy se rechaza
  sin tocar el checkout y remite a su etiqueta histórica.
- Los conflictos con archivos no gestionados por Dotbot se preservan: la fase
  de configuración se detiene en vez de sobrescribirlos.
- NVIDIA, Secure Boot, importación de AppImages y presets de Input Remapper
  requieren comprobaciones o acciones posteriores descritas en las guías.
