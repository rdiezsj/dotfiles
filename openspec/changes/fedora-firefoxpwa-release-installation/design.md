# Design

## Context

El catálogo actual trata `firefoxpwa` como un paquete DNF y añade un repositorio Packagecloud. Ese repositorio no contiene paquetes RPM, mientras que la release oficial de PWAsForFirefox publica el RPM x86_64 requerido para Fedora Workstation. Véanse `proposal.md` y sus especificaciones delta.

## Goals / Non-Goals

**Goals:**

- Instalar una release concreta de Firefox PWA de forma reproducible, con integridad verificable e idempotencia.
- Mantener Firefox PWA como una responsabilidad diferenciada del bucle de paquetes DNF ordinarios.
- Dejar de configurar Packagecloud en instalaciones nuevas sin tocar fuentes externas ajenas ni repositorios locales existentes.

**Non-Goals:**

- Resolver versiones de Firefox PWA dinámicamente durante el bootstrap.
- Mantener actualizaciones automáticas de Firefox PWA fuera de las versiones declaradas en el repositorio.
- Gestionar instalaciones de Firefox PWA de arquitecturas distintas de x86_64.

## Decisions

### RPM de GitHub Release con versión y suma declaradas

Se añadirá un catálogo específico para Firefox PWA que contenga versión, URL de release oficial, nombre RPM y SHA-256. El ejecutor descargará en un temporal, verificará la suma y pedirá a DNF que instale el archivo local. Antes, comprobará con RPM si la versión declarada ya está presente.

Alternativa descartada: conservar Packagecloud. El repositorio no publica el paquete y hace que el resultado dependa de una fuente no funcional.

Alternativa descartada: consultar la última release en cada bootstrap. Reduciría la reproducibilidad, introduciría dependencias de red adicionales y evitaría la revisión explícita de nuevas versiones y sumas.

### Sin migración de repositorios locales

La fase de fuentes externas dejará de crear `firefoxpwa.repo` y no inspeccionará, modificará ni eliminará archivos existentes en `/etc/yum.repos.d/`. El alcance es una Fedora recién instalada, donde la versión corregida de los dotfiles nunca habrá configurado Packagecloud.

### Resultado y pruebas diferenciados

El resumen distinguirá Firefox PWA de los paquetes DNF: instalado, presente, omitido por arquitectura no compatible o fallido por descarga, integridad o instalación. Las pruebas usarán dobles para `curl`, `sha256sum`, `rpm`, `dnf` y las rutas temporales, sin red ni cambios en el equipo real.

## Risks / Trade-offs

- [La release declarada deja de estar disponible] → registrar el fallo sin instalar un artefacto alternativo y actualizar el catálogo solo tras revisar una nueva release.
- [Una instalación existente procede de otra versión] → DNF recibe el RPM versionado y resuelve la actualización o informa del conflicto.
- [Repositorio Packagecloud existente] → no actuar sobre él; la instalación desde la release oficial funciona de forma independiente.

## Migration Plan

1. Simular la instalación del RPM declarado, sin operaciones sobre repositorios locales.
2. Ejecutar el bootstrap y verificar la suma antes de que DNF instale Firefox PWA.
3. Reejecutar el bootstrap para comprobar que la versión declarada se informa como presente.
4. Para volver atrás, restaurar una declaración de fuente en el repositorio solo si Packagecloud vuelve a publicar una fuente verificable y se aprueba una revisión del catálogo.
