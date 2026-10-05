# Design

## Context

El catálogo actual trata `firefoxpwa` como un paquete DNF y añade un repositorio Packagecloud. Ese repositorio no contiene paquetes RPM y la descarga directa de la release ha fallado en Fedora. Homebrew ya se instala como dependencia esencial y publica una fórmula con botella para Linux x86_64.

## Goals / Non-Goals

**Goals:**

- Instalar Firefox PWA mediante Homebrew de forma idempotente.
- Mantener Firefox PWA como una responsabilidad diferenciada del bucle de paquetes DNF ordinarios y reutilizable por el catálogo Homebrew posterior.
- Dejar de configurar Packagecloud en instalaciones nuevas sin tocar fuentes externas ajenas ni repositorios locales existentes.

**Non-Goals:**

- Gestionar Firefox PWA con DNF, Packagecloud o RPMs descargados directamente.
- Configurar automáticamente la extensión del navegador o crear PWAs.

## Decisions

### Fórmula Homebrew declarada

`catalogs/homebrew.sh` declarará `firefoxpwa`. El ejecutor del catálogo consultará `brew list --versions` por fórmula e instalará únicamente las ausentes después de que Homebrew esté disponible. Los resultados usarán las categorías ya empleadas por el resumen: instalado, presente y fallido.

Alternativa descartada: conservar Packagecloud. El repositorio no publica el paquete y hace que el resultado dependa de una fuente no funcional.

Alternativa descartada: descargar el RPM de GitHub Releases. Añade una ruta de actualización y verificación paralela a Homebrew que no ha funcionado en la VM.

### Sin migración de repositorios locales

La fase de fuentes externas dejará de crear `firefoxpwa.repo` y no inspeccionará, modificará ni eliminará archivos existentes en `/etc/yum.repos.d/`. El alcance es una Fedora recién instalada, donde la versión corregida de los dotfiles nunca habrá configurado Packagecloud.

### Resultado y pruebas por fórmula

El resumen distinguirá Firefox PWA de los paquetes DNF: instalado, presente o fallido mediante Homebrew. Las pruebas usarán dobles para `brew`, sin red ni cambios en el equipo real.

## Risks / Trade-offs

- [La fórmula no está disponible] → registrar el fallo y continuar con el resto del catálogo.
- [Homebrew no está disponible] → registrar Firefox PWA como fallido sin intentar una fuente alternativa.
- [Repositorio Packagecloud existente] → no actuar sobre él; Homebrew funciona de forma independiente.

## Migration Plan

1. Simular la instalación de la fórmula, sin operaciones sobre repositorios locales.
2. Ejecutar el bootstrap y comprobar que Homebrew instala Firefox PWA.
3. Reejecutar el bootstrap para comprobar que la fórmula se informa como presente.
4. Para volver atrás, revisar una fuente alternativa en un nuevo cambio; no restaurar Packagecloud automáticamente.
