# Design

## Context

El catálogo Flatpak y su documentación son declarativos, mientras que el
ejecutor configura el remoto de usuario e instala cada identificador. Véanse
`proposal.md` y la delta de `fedora-software-catalog` para la motivación y el
contrato de comportamiento.

## Goals / Non-Goals

**Goals:**

- Incorporar la aplicación oficial GNOME Extensions en el catálogo Flatpak.
- Usar exclusivamente el remoto Flathub oficial para el catálogo de usuario.
- Cubrir la declaración y la instalación con pruebas aisladas de comandos.

**Non-Goals:**

- Instalar, activar o versionar extensiones concretas de GNOME Shell.
- Cambiar el alcance del catálogo DNF, Homebrew o AppImage.
- Alterar remotos Flatpak de otros usuarios o del sistema.

## Decisions

### Identificador publicado por Flathub

Se declarará `org.gnome.Extensions`, el identificador de la aplicación GNOME
Extensions publicada por el proyecto GNOME en Flathub. Se descarta
`com.mattjakeman.ExtensionManager`, pues es otra aplicación mantenida por un
tercero y no satisface la selección indicada.

### Remoto de usuario oficial y validado

El ejecutor consultará la URL de `flathub` para el usuario. Si no existe o no
coincide con la URL oficial, lo añadirá o actualizará con la URL declarada. Así
la instalación posterior conserva el ámbito `--user` y no instala desde un
remoto homónimo de origen distinto. Se descarta aceptar cualquier remoto solo
por llamarse `flathub`.

### Pruebas enfocadas

Las pruebas comprobarán que el catálogo contiene el identificador y que el
ejecutor invoca la instalación con `--user`, el remoto `flathub` y ese ID. Los
dobles de `flatpak` verificarán la URL oficial sin requerir una estación Fedora
ni modificar remotos reales.

## Risks / Trade-offs

- Un remoto `flathub` de usuario con una URL personalizada se sustituirá por la
  oficial → es necesario para cumplir el origen explícito del catálogo; el
  cambio queda limitado al perfil que ejecuta el bootstrap.
- La aplicación Flatpak puede requerir runtimes adicionales → Flatpak los
  resolverá durante la instalación y el resumen existente comunicará cualquier
  fallo.

## Migration Plan

1. Ejecutar el bootstrap tras revisar su plan y confirmarlo.
2. El catálogo actualizará el remoto de usuario si procede e instalará GNOME
   Extensions si aún no está presente.
3. Si se requiere revertir, retirar únicamente `org.gnome.Extensions` del
   catálogo y desinstalarlo con Flatpak; no se modificarán extensiones de Shell.
