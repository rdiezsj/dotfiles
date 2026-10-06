# Spec Delta

## Purpose

Reproduce las instrucciones y skills globales de Codex de forma consistente en las cuentas y equipos Fedora configurados con estos dotfiles.

## ADDED Requirements

### Requirement: Instrucciones globales de Codex versionadas
El sistema SHALL conservar `~/.codex/AGENTS.md` en el repositorio y SHALL enlazarlo a su destino global de Codex.

#### Scenario: Instrucciones desplegadas
- **WHEN** Dotbot aplica la configuración de Codex
- **THEN** `~/.codex/AGENTS.md` resuelve al fichero versionado `home/.codex/AGENTS.md`

### Requirement: Skills globales de Codex versionadas
El sistema SHALL conservar y enlazar íntegramente el árbol `~/.codex/skills/`, incluidos archivos ocultos, subdirectorios, recursos y `.system/`.

#### Scenario: Skills desplegadas
- **WHEN** Dotbot aplica la configuración de Codex
- **THEN** `~/.codex/skills` resuelve al árbol versionado `home/.codex/skills` y mantiene la misma estructura y contenido

#### Scenario: Recursos anidados u ocultos
- **WHEN** una skill contiene referencias, scripts, assets, subdirectorios o archivos ocultos
- **THEN** esos elementos permanecen en su ruta relativa original y son accesibles a través del enlace global

### Requirement: Conflictos en destinos globales Codex
El sistema SHALL pedir confirmación antes de mover destinos Codex existentes que no estén gestionados, SHALL conservarlos en un respaldo recuperable y SHALL cancelar sin cambios si se rechaza la confirmación.

#### Scenario: Sustitución confirmada
- **WHEN** `~/.codex/AGENTS.md` o `~/.codex/skills` existe y no apunta al contenido versionado, y la persona confirma la migración
- **THEN** el sistema respalda el destino existente y aplica el enlace versionado

#### Scenario: Sustitución rechazada
- **WHEN** la persona rechaza la migración de un destino Codex no gestionado
- **THEN** el destino original permanece intacto y no se aplica esa fase de enlaces
