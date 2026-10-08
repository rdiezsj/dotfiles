# Design

## Context

El bootstrap instala desde catálogos separados DNF/RPM, Homebrew, Flatpak y
AppImage, y configura extensiones GNOME desde RPM o extensions.gnome.org. El
checkout desplegado está previsto en `~/.dotfiles`; Dotbot ya detecta destinos
locales no gestionados antes de modificarlos. Véase `proposal.md` para la
motivación y `specs/workstation-updates/spec.md` para el contrato observable.

## Goals / Non-Goals

**Goals:**

- Reunir el mantenimiento de las fuentes declaradas en una única rutina
  reutilizable, invocada mediante el alias `update`.
- Mantener la operación no interactiva sin convertirla en una sobrescritura
  destructiva: solo avance rápido de Git y solo destinos Dotbot gestionados.
- Reutilizar los catálogos y las comprobaciones existentes en vez de duplicar
  inventarios de paquetes.

**Non-Goals:**

- No ejecutar `./bootstrap`, reinstalar el catálogo ni reconfigurar
  Vaultwarden, NVIDIA, servicios o la shell.
- No actualizar software local ajeno al catálogo, ni importar AppImage en Gear
  Lever, ni modificar preferencias GNOME no versionadas.
- No resolver conflictos Git/Dotbot de forma automática, ni reiniciar el
  equipo.

## Decisions

### Script separado en el checkout desplegado

Se añadirá un script Bash específico y el alias Zsh lo invocará desde
`~/.dotfiles`. Esto desacopla el mantenimiento repetible del bootstrap, que
conserva sus confirmaciones y su responsabilidad de instalación inicial.

Alternativas consideradas:

- Extender `bootstrap`: descartado porque volvería a ejecutar fases de
  instalación/configuración no necesarias y exigiría alterar su contrato de
  confirmación.
- Alias con todos los comandos: descartado para poder probar, resumir fallos y
  reutilizar funciones con seguridad.

### Sincronización conservadora antes de actualizar software

La rutina validará el checkout, recuperará su remoto y aplicará solo un avance
rápido a la referencia configurada. Un árbol con cambios, una referencia
divergente o una descarga fallida interrumpirán esa fase sin alterar el árbol;
las demás fuentes independientes podrán continuar y el resultado final fallará.

Dotbot se ejecutará únicamente después de esa sincronización y conservará su
política de no reemplazar destinos no gestionados. Así "si hay diferencias"
actualiza enlaces ya gestionados, sin borrar configuración local.

Alternativa considerada: `git pull` o Dotbot forzado. Se descarta porque ambos
podrían fusionar o reemplazar estado local sin intervención, incompatible con
la preservación de datos.

### Adaptadores por gestor y alcance declarado

El script organizará una fase por gestor: DNF (actualización de metadatos,
repositorios y paquetes), Homebrew, Flatpak de usuario, AppImage declarados y
extensiones GNOME declaradas. Cada adaptador devolverá un resultado estructurado
al resumen y continuará con los restantes aunque falle.

DNF actualizará también las extensiones empaquetadas RPM. Para extensiones de
extensions.gnome.org y AppImage, el adaptador reutilizará sus declaraciones de
origen y validación y solo sustituirá una instalación existente tras confirmar
compatibilidad e integridad. Los AppImage fijados hoy no se tratarán como un
inventario genérico de `~/Apps`: la implementación deberá ampliar su catálogo
con una fuente oficial de versión y suma verificables para admitir actualización
automática.

Alternativa considerada: recorrer todos los AppImage y extensiones instalados.
Se descarta porque no existe un mecanismo universal y se perdería la garantía
de origen/compatibilidad.

### Privilegios y no interactividad

Los comandos de sistema usarán sus variantes no interactivas. La rutina no
pedirá confirmación propia; si `sudo` requiere autenticación, será el mecanismo
del sistema quien la solicite. No se almacenarán ni transmitirán credenciales.

## Risks / Trade-offs

- [Un checkout local con trabajo pendiente bloquea la actualización de
  configuraciones] → se conserva íntegramente y el resumen aporta el motivo;
  la persona resuelve el estado Git antes de repetir.
- [Una actualización de DNF puede necesitar reinicio] → se detecta y comunica,
  sin reinicio automático.
- [No hay metadatos verificables para un AppImage declarado] → se conserva la
  versión anterior y se registra la falta de actualización, sin descargar una
  versión no autenticada.
- [GNOME Shell no admite una extensión nueva] → se valida su compatibilidad y
  se conserva la instalación funcional existente.
- [Un gestor no está disponible] → se marca la fase como fallida, se continúan
  las independientes y el código final es no nulo.

## Migration Plan

1. Añadir el script, alias, adaptadores mínimos y pruebas aisladas con stubs de
   Git, Dotbot y cada gestor.
2. Ejecutar la suite unitaria y validación OpenSpec estricta sin ejecutar el
   mantenimiento real en este checkout de desarrollo.
3. Tras desplegar los dotfiles en una estación Fedora objetivo, invocar
   `update`, comprobar el resumen y resolver manualmente cualquier reinicio o
   conflicto informado.

No hay migración de datos ni cambio irreversible. Para revertir, se elimina el
alias y el script en un cambio posterior; las actualizaciones de paquetes ya
aplicadas se gestionan con las herramientas de cada gestor.
