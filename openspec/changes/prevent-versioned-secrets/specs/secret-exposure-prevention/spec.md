# Spec Delta

## Purpose

Evita que secretos detectables se incorporen al historial del repositorio sin
enviar su contenido a un servicio externo de análisis.

## ADDED Requirements

### Requirement: Comprobación local de cambios preparados
El repositorio SHALL proporcionar una comprobación local que analice los
cambios preparados para Git antes de crear un commit y rechace el commit si
detecta un secreto no permitido.

#### Scenario: Cambio preparado sin secretos
- **WHEN** la persona crea un commit con cambios preparados que no contienen
  secretos detectables
- **THEN** la comprobación local finaliza correctamente y permite el commit

#### Scenario: Secreto detectado antes del commit
- **WHEN** la comprobación local detecta un secreto no permitido en los cambios
  preparados
- **THEN** rechaza el commit e informa de una corrección sin imprimir el valor
  detectado

### Requirement: Comprobación de secretos en integración continua
El repositorio SHALL ejecutar en integración continua una comprobación de
secretos sobre el historial accesible del cambio y SHALL marcar el flujo como
fallido si detecta un secreto no permitido.

#### Scenario: Análisis de una propuesta de cambio
- **WHEN** se abre o actualiza una propuesta de cambio contra `main`
- **THEN** la integración continua analiza el historial alcanzable de la
  propuesta y publica un resultado correcto o fallido

#### Scenario: Detección en integración continua
- **WHEN** la comprobación de integración continua detecta un secreto no
  permitido
- **THEN** el flujo falla sin incluir el valor detectado en sus mensajes

### Requirement: Gestión revisable de falsos positivos
El repositorio SHALL mantener las excepciones de detección bajo control de
versiones, con una justificación que no revele secretos, y SHALL documentar el
procedimiento para corregir una detección o solicitar una excepción.

#### Scenario: Falso positivo confirmado
- **WHEN** una detección se clasifica como falso positivo
- **THEN** la excepción queda registrada de forma revisable y el análisis
  posterior no bloquea únicamente por esa detección
