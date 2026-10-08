# Design

## Context

El repositorio no tiene automatización técnica distinta de la publicación de
documentación. Ya existen comprobaciones puntuales para que las configuraciones
versionadas no contengan secretos, pero no una inspección transversal de los
cambios ni del historial. La propuesta define el alcance funcional.

## Goals / Non-Goals

**Goals:**

- Detectar secretos antes del commit y al integrar cambios.
- Mantener el análisis local, reproducible y sin enviar contenido del
  repositorio a terceros.
- Conservar excepciones mínimas, auditables y justificadas.

**Non-Goals:**

- Revocar, rotar o eliminar secretos ya publicados.
- Sustituir Vaultwarden, GNOME Keyring o las validaciones existentes de msmtp.
- Ejecutar el análisis como parte del bootstrap de una estación Fedora.

## Decisions

- Usar Gitleaks como único motor de detección, con configuración versionada.
  Aporta detectores mantenidos y permite analizar cambios e historial sin un
  servicio remoto. Se descartan reglas Bash propias por su menor cobertura y
  mayor mantenimiento.
- Instalar un hook `pre-commit` versionado mediante una herramienta de hooks
  para analizar únicamente los cambios preparados. El hook ofrece una barrera
  rápida; no es la única garantía, porque puede omitirse o no estar instalado.
- Ejecutar Gitleaks en GitHub Actions ante propuestas contra `main`, cambios en
  `main` y ejecución manual. El flujo obtendrá el historial necesario para que
  una credencial introducida en un commit previo de la rama no quede fuera del
  análisis.
- Centralizar las excepciones en la configuración del detector, identificadas
  por la regla y la ubicación o huella que admita la herramienta. Cada entrada
  tendrá comentario justificativo y no incluirá el secreto.
- Fijar las acciones y versiones de herramientas a referencias revisables. Se
  evita depender de versiones flotantes en un control de seguridad.

## Risks / Trade-offs

- [Falsos positivos sobre valores de prueba] → Preferir valores claramente
  sintéticos y añadir una excepción específica solo tras revisarla.
- [El hook no está instalado o se salta] → Mantener la comprobación de CI como
  control obligatorio independiente.
- [El análisis de historial aumenta el tiempo de CI] → Limitarlo al historial
  relevante del evento y ejecutarlo en paralelo con la publicación documental.
- [Un secreto ya publicado requiere respuesta urgente] → Documentar la
  revocación inmediata; borrar el texto no sustituye revocar la credencial.

## Migration Plan

1. Añadir la configuración, hook, flujo y documentación con el análisis en
   modo bloqueante.
2. Ejecutar el análisis sobre el historial actual y resolver cualquier
   detección antes de integrar el cambio.
3. Para retirar la protección, eliminar primero el hook y el workflow; las
   excepciones pueden conservarse solo mientras exista el detector.
