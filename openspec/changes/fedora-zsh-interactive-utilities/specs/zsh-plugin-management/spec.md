# zsh-plugin-management Specification

## Purpose

Gestiona los plugins Zsh de forma declarativa, reproducible y separada de Oh My Zsh mediante Sheldon.

## ADDED Requirements

### Requirement: Declaración y bloqueo de plugins
El sistema SHALL instalar Sheldon mediante Homebrew y SHALL mantener versionados una configuración declarativa y un lockfile con revisiones concretas para cada plugin. El caché local de Sheldon SHALL permanecer fuera del repositorio.

#### Scenario: Primera instalación
- **WHEN** el bootstrap se ejecuta en una cuenta Fedora compatible
- **THEN** instala Sheldon, enlaza su configuración versionada y genera o valida el lockfile antes de cargar los plugins

#### Scenario: Referencia no bloqueada
- **WHEN** la configuración declara un plugin sin una revisión bloqueada o el lockfile no coincide
- **THEN** el bootstrap detiene la fase de plugins y explica cómo regenerar el lockfile explícitamente

### Requirement: Plugins mínimos sin Oh My Zsh completo
Sheldon SHALL cargar, en un orden determinista, los plugins de completions, autosuggestions, autopair, resaltado de sintaxis y los scripts `sudo` y `extract` seleccionados de sus repositorios de origen, sin instalar ni inicializar el framework completo de Oh My Zsh. La configuración SHALL ejecutarse solo en shells interactivas.

#### Scenario: Shell interactiva
- **WHEN** se inicia una shell Zsh interactiva
- **THEN** están disponibles las sugerencias, el emparejado de delimitadores, el resaltado, `sudo` con doble Escape y `extract`

#### Scenario: Shell no interactiva
- **WHEN** un script ejecuta Zsh sin modo interactivo
- **THEN** no carga plugins ni emite mensajes de inicialización

### Requirement: Actualización controlada
El sistema SHALL documentar `sheldon lock --update` como operación explícita de mantenimiento y SHALL ejecutar `sheldon source` usando el lockfile existente durante el arranque, sin actualizar repositorios automáticamente en cada shell.

#### Scenario: Actualización solicitada
- **WHEN** la persona usuaria solicita actualizar plugins
- **THEN** el procedimiento regenera el lockfile, muestra las revisiones resultantes y permite revisar el diff antes de versionarlo

#### Scenario: Arranque repetido
- **WHEN** se abre una segunda shell sin cambios en la configuración
- **THEN** Sheldon reutiliza el lockfile y no descarga ni reinstala plugins innecesariamente
