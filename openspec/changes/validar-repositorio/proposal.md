# Proposal

## Why

El repositorio ya dispone de una validación integrada local, pero los cambios
pueden llegar a `main` sin ejecutar esa barrera de sintaxis Bash, pruebas,
documentación y contratos OpenSpec en un entorno limpio.

## What Changes

- Añadir el workflow de GitHub Actions `validar-repositorio.yml`, visible como
  **Validar repositorio**.
- Ejecutar la validación integrada en propuestas contra `main`, cambios en
  `main` y ejecuciones manuales.
- Preparar en el runner las dependencias necesarias para ejecutar todas las
  comprobaciones locales sin omitir la construcción estricta de documentación.
- Mantener la publicación de Pages y el análisis de secretos como workflows
  independientes.
- Documentar los tres workflows públicos, su alcance y cómo reproducir sus
  comprobaciones localmente.

## Capabilities

### New Capabilities

- `repository-validation`: Verifica de forma reproducible la integridad técnica
  del repositorio antes y después de integrar cambios.

### Modified Capabilities

- Ninguna.

## Impact

- Nuevo workflow de GitHub Actions, su badge en el README y una guía de
  automatización enlazada desde la documentación.
- Dependencias de validación disponibles solo en el runner efímero.
- Las pruebas existentes, `scripts/check.sh` y las especificaciones OpenSpec se
  ejecutarán como una única barrera de integración.
