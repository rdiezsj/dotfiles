# Design

## Context

El catálogo actual separa DNF, Flatpak, Homebrew y AppImage, pero no dispone
de un bloque de extensiones GNOME. Véanse `proposal.md` y las deltas de esta
propuesta para la motivación y el contrato de comportamiento.

## Goals / Non-Goals

**Goals:**

- Mantener las extensiones con paquetes Fedora cuando existen.
- Instalar desde extensions.gnome.org únicamente las extensiones sin paquete
  oficial Fedora y compatibles con la versión de GNOME Shell instalada.
- Activar el conjunto con UUIDs declarados y sin versionar preferencias.

**Non-Goals:**

- Clonar repositorios, compilar extensiones, usar COPR o instalar versiones no
  compatibles.
- Configurar preferencias individuales, otras extensiones o el navegador.
- Reiniciar GNOME Shell, cerrar sesión o reiniciar el equipo automáticamente.

## Decisions

### Origen por mantenimiento

AppIndicator y Dash to Dock se declararán en DNF. Custom Hot Corners Extended,
Clipboard Indicator y Vitals se resolverán desde extensions.gnome.org para la
versión de GNOME Shell detectada. Se descartan GitHub, compilación y COPR por
incrementar la carga de actualización y el riesgo de incompatibilidad.

### Instalación de usuario y activación declarativa

El ejecutor conservará una tabla con nombre, UUID y origen de las cinco
extensiones. Para las publicadas en extensions.gnome.org consultará la
publicación compatible, descargará el archivo temporal e instalará para el
usuario mediante `gnome-extensions`; después verificará y activará cada UUID.
Los paquetes DNF se activarán con el mismo paso, sin reinstalarlos.

### Fase visible y tolerante a fallos

El bootstrap mostrará «Extensiones GNOME» como fase independiente tras el
catálogo de software. Un fallo de una extensión se registrará y permitirá que
el resto continúe; el resumen conservará la instrucción de reinicio de sesión
manual cuando proceda.

## Risks / Trade-offs

- extensions.gnome.org puede no publicar aún una versión para una nueva GNOME
  Shell → se omitirá la instalación de esa extensión y se explicará el motivo.
- Las extensiones son estado de usuario y pueden presentar incompatibilidades
  entre sí tras una actualización → las preferencias quedan locales y el
  bloque comunica la extensión concreta afectada.
- Vitals requiere acceso a sensores locales → DNF instala sus dependencias,
  pero la disponibilidad de sensores sigue dependiendo del hardware.

## Migration Plan

1. Ejecutar el bootstrap en una estación Fedora compatible tras revisar su
   plan y confirmarlo.
2. Instalar los paquetes DNF y procesar el bloque de extensiones para el
   usuario actual.
3. Cerrar e iniciar sesión manualmente si GNOME Shell no carga de inmediato
   una extensión activada.
4. Para revertir, desactivar o desinstalar una extensión desde GNOME Extensions
   y retirar su paquete DNF solo cuando corresponda.
