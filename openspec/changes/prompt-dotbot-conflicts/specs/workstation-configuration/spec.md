# Spec Delta

## MODIFIED Requirements

### Requirement: Dotbot sin sobrescritura implícita
El sistema SHALL detectar y mostrar todos los destinos no gestionados antes de ejecutar Dotbot. Para cada conflicto SHALL mostrar el destino y el origen versionado, y pedir confirmación explícita antes de crear un respaldo fechado y aplicar el enlace. No reemplazará ni moverá archivos sin esa confirmación.

#### Scenario: Conflicto con destino no gestionado
- **WHEN** una ruta objetivo contiene un archivo o enlace no gestionado
- **THEN** el sistema muestra la ruta y el origen versionado, y conserva el archivo si la confirmación se rechaza

#### Scenario: Aplicación confirmada
- **WHEN** la persona confirma aplicar un destino no gestionado
- **THEN** el sistema crea un respaldo recuperable, enlaza el origen versionado y comunica ambas rutas
