# Proposal

## Why

El bootstrap instala varias aplicaciones, pero sus preferencias portables aún no
se declaran ni se aplican de forma reproducible. Esto obliga a repetir ajustes
editoriales y visuales en cada estación y deja sin una frontera clara los datos
locales, las credenciales y las configuraciones dependientes del hardware.

## What Changes

- Versionar y enlazar mediante Dotbot las configuraciones portables de Nano,
  Vim, Git, Terminator, Flameshot, Heynote e Input Remapper 2.
- Añadir `nano`, `flameshot` y `msmtp` al catálogo DNF declarativo.
- Instalar `msmtp` para que su ejecutable esté disponible en el sistema y
  versionar una configuración skeleton activa sin valores de cuenta ni
  credenciales.
- Declarar la cuenta SMTP IONOS sin secretos y recuperar bajo demanda el
  usuario y la contraseña desde el ítem de Vaultwarden `Mail.ionos.es`.
- Mantener las decisiones aún personales como plantillas: tamaño de tabulación
  de Nano y Vim, ruta de guardado de Flameshot y parámetros SMTP.
- Versionar exclusivamente `config.json` y `Preferences` de Heynote; no incluir
  buffers, notas, sesiones ni cachés.
- Versionar presets explícitos de Input Remapper 2, sin habilitar un autoload
  ligado a un dispositivo físico hasta que se complete localmente.
- Tratar Gear Lever como una configuración curada: no enlazar su sandbox
  Flatpak ni el inventario de AppImages, rutas o estado de actualizaciones.

## Capabilities

### New Capabilities

- `application-configuration`: Declara configuraciones de aplicaciones que son
  portables, separa plantillas de datos locales y mantiene fuera del repositorio
  credenciales, cachés, notas y estado dependiente del equipo.

### Modified Capabilities

- `fedora-software-catalog`: El catálogo DNF incorporará Nano, Flameshot y
  msmtp.

## Impact

- Afecta a `install.conf.yaml`, `home/`, el catálogo DNF, el orquestador del
  bootstrap y sus pruebas unitarias.
- Añade los paquetes DNF `nano`, `msmtp` y `flameshot`.
- No añade repositorios externos, no modifica el modelo de AppImage ni guarda
  secretos, identidades Git, datos de aplicaciones o credenciales SMTP.
