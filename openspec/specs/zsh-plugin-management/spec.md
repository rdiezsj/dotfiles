# zsh-plugin-management Specification

## Purpose

Gestiona los plugins Zsh de forma declarativa, reproducible y separada de Oh My Zsh mediante Sheldon.

## Requirements

### Requirement: Declaración y bloqueo de plugins
El sistema SHALL instalar Sheldon mediante Homebrew y SHALL mantener versionada una configuración declarativa con SHA concretos para cada plugin. Los lockfiles y el caché local de Sheldon SHALL permanecer fuera del repositorio por contener rutas específicas del equipo.

#### Scenario: Primera instalación
- **WHEN** el bootstrap se ejecuta en una cuenta Fedora compatible
- **THEN** instala Sheldon, enlaza su configuración versionada y materializa localmente las revisiones fijadas antes de cargar los plugins

#### Scenario: Referencia no bloqueada
- **WHEN** la configuración declara un plugin sin una revisión SHA válida
- **THEN** el bootstrap detiene la fase de plugins y explica cómo fijar una revisión explícitamente

### Requirement: Plugins mínimos sin Oh My Zsh completo
Sheldon SHALL cargar, en un orden determinista, los plugins de completions, autosuggestions, autopair, resaltado de sintaxis y los scripts `sudo` y `extract` seleccionados de sus repositorios de origen, sin instalar ni inicializar el framework completo de Oh My Zsh. La configuración SHALL ejecutarse solo en shells interactivas.

#### Scenario: Shell interactiva
- **WHEN** se inicia una shell Zsh interactiva
- **THEN** están disponibles las sugerencias, el emparejado de delimitadores, el resaltado, `sudo` con doble Escape y `extract`

#### Scenario: Shell no interactiva
- **WHEN** un script ejecuta Zsh sin modo interactivo
- **THEN** no carga plugins ni emite mensajes de inicialización

### Requirement: Actualización controlada
El sistema SHALL documentar la actualización de SHA como operación explícita de mantenimiento y SHALL ejecutar `sheldon source` usando el estado local existente durante el arranque, sin actualizar repositorios automáticamente en cada shell.

#### Scenario: Actualización solicitada
- **WHEN** la persona usuaria solicita actualizar plugins
- **THEN** el procedimiento actualiza los SHA, muestra las revisiones resultantes y permite revisar el diff antes de versionarlo

#### Scenario: Arranque repetido
- **WHEN** se abre una segunda shell sin cambios en la configuración
- **THEN** Sheldon reutiliza el estado local y no descarga ni reinstala plugins innecesariamente

### Requirement: Entorno Zsh interactivo
La configuración SHALL declarar `DOTFILES` con valor predeterminado `~/.dotfiles`, deduplicar `path` y `PATH`, y añadir únicamente directorios existentes de `~/.local/bin`, `~/.dotfiles/bin` y `~/.krew/bin`. SHALL activar `bindkey -e`, conservar opciones FZF preexistentes y añadir `--height 40%`, `--layout=reverse` y `--border`. SHALL cargar el completado de kubectl después de `compinit` cuando `kubectl` esté disponible.

#### Scenario: Directorios personales disponibles
- **WHEN** una shell interactiva se inicia y existen directorios personales de binarios
- **THEN** aparecen una sola vez en `PATH`, `DOTFILES` referencia el repositorio y Homebrew conserva la gestión de sus propias rutas

#### Scenario: Búsqueda de historial con fzf
- **WHEN** fzf está disponible en una shell interactiva
- **THEN** Ctrl+R usa el enlace de fzf en modo de edición Emacs con la interfaz compacta configurada

#### Scenario: Kubectl instalado
- **WHEN** `kubectl` está disponible tras inicializar completions
- **THEN** sus subcomandos y recursos se completan mediante su definición Zsh

### Requirement: Recarga opcional de la sesión
El bootstrap SHALL mostrar el resumen final antes de ofrecer, solo si no hubo fallos, abrir una Zsh de inicio de sesión. SHALL requerir una confirmación independiente y ejecutar `exec zsh -l` únicamente tras aceptarla.

#### Scenario: Bootstrap correcto
- **WHEN** todas las fases terminan sin fallos y ya se mostró el resumen final
- **THEN** pregunta si debe abrir Zsh y conserva la Bash actual si la respuesta se rechaza

#### Scenario: Bootstrap con incidencias o simulación
- **WHEN** el bootstrap termina con fallos o se ejecuta en simulación
- **THEN** no ofrece ni ejecuta la recarga de sesión
