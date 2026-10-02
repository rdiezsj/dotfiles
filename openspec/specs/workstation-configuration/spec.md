# workstation-configuration Specification

## Purpose

Prepara la estructura inicial de la estación y sus plantillas Nautilus sin sobrescribir configuración personal no gestionada.

## Requirements

### Requirement: Scaffold y plantillas iniciales
El sistema SHALL crear el scaffold declarativo de carpetas esenciales y las plantillas Nautilus iniciales de texto, Markdown y shell.

#### Scenario: Equipo sin estructura previa
- **WHEN** se confirma el bootstrap en un usuario nuevo
- **THEN** se crean las carpetas y las tres plantillas sin intervención adicional

### Requirement: Dotbot sin sobrescritura implícita
El sistema SHALL preparar la configuración mínima de Dotbot y SHALL detenerse si una ruta objetivo contiene un archivo o enlace no gestionado.

#### Scenario: Conflicto con destino no gestionado
- **WHEN** una ruta objetivo contiene un archivo o enlace no gestionado
- **THEN** el sistema no lo reemplaza, explica el conflicto y solicita una confirmación humana explícita para continuar

### Requirement: Reejecución sin cambios innecesarios
El sistema SHALL reconocer el scaffold, las plantillas y los enlaces gestionados ya conformes y SHALL omitir su modificación en una segunda ejecución.

#### Scenario: Segunda ejecución conforme
- **WHEN** se ejecuta el bootstrap por segunda vez sin desviaciones
- **THEN** informa de los elementos ya satisfechos y no los reinstala ni sobrescribe
