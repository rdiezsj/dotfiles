# Proposal

## Why

El repositorio declara que no contiene secretos y ya evita almacenarlos en sus
configuraciones, pero no dispone de una barrera automatizada que detecte una
credencial añadida por error antes de integrarla en `main`.

## What Changes

- Añadir una comprobación local que analice los cambios preparados para Git sin
  transmitir su contenido a servicios externos.
- Añadir una comprobación de integración continua que analice el historial
  accesible de cada cambio y bloquee el flujo si detecta secretos.
- Documentar cómo interpretar, corregir y marcar como falsa positiva una
  detección, sin incorporar secretos de ejemplo.

## Capabilities

### New Capabilities

- `secret-exposure-prevention`: Previene que secretos detectables se incorporen
  al historial o a cambios integrados del repositorio.

### Modified Capabilities

- Ninguna.

## Impact

- Nuevos archivos de configuración y automatización de Git y GitHub Actions.
- Nueva herramienta de análisis de secretos para desarrollo y CI.
- Documentación de contribución y pruebas de la configuración de análisis.
- No se modifica el bootstrap, Vaultwarden, GNOME Keyring ni el contenido de
  credenciales existente.
