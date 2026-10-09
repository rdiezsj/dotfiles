# Spec Delta

## Purpose

Verifica en GitHub Actions que los cambios preservan la integridad técnica del
repositorio antes de integrarlos y después de incorporarlos a `main`.

## ADDED Requirements

### Requirement: Validación integrada del repositorio
El repositorio SHALL ejecutar una validación integrada en un runner limpio que
compruebe la sintaxis Bash, las pruebas unitarias y la documentación estricta,
sin requerir herramientas de planificación del desarrollo.

#### Scenario: Cambio conforme
- **WHEN** una propuesta o cambio integrado cumple todas las comprobaciones
  técnicas del repositorio
- **THEN** el workflow termina correctamente sin publicar ni modificar el
  repositorio

#### Scenario: Regresión detectada
- **WHEN** cualquiera de las comprobaciones integradas falla
- **THEN** el workflow termina como fallido e identifica la comprobación que
  impidió validarlo

### Requirement: Cobertura de eventos de integración
El sistema SHALL ejecutar la validación integrada para propuestas contra
`main`, cambios incorporados a `main` y ejecuciones manuales.

#### Scenario: Propuesta contra main
- **WHEN** se abre o actualiza una propuesta dirigida a `main`
- **THEN** el workflow valida el estado de esa propuesta antes de integrarla

#### Scenario: Ejecución manual
- **WHEN** una persona inicia manualmente el workflow
- **THEN** el workflow ejecuta la misma validación integrada sobre la
  referencia seleccionada

### Requirement: Estado visible de validación
El README SHALL enlazar un badge del workflow de validación de repositorio que
muestre el estado de sus ejecuciones de `main` activadas por cambios.

#### Scenario: Consulta del README
- **WHEN** una persona abre el README del repositorio
- **THEN** encuentra un badge que enlaza a las ejecuciones del workflow de
  validación de repositorio

### Requirement: Documentación de automatización
La documentación SHALL explicar los workflows públicos del repositorio, sus
disparadores, finalidad, límites y la reproducción local de sus validaciones.

#### Scenario: Consulta de automatización
- **WHEN** una persona consulta la documentación del repositorio
- **THEN** puede distinguir la validación del repositorio, el análisis de
  secretos y la publicación de documentación, y conoce la comprobación local
  aplicable a cada uno
