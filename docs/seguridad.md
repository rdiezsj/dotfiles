# Prevención de secretos

El repositorio protege su historial con Gitleaks. El análisis se ejecuta antes
de cada commit cuando el hook está instalado y también en GitHub Actions para
las propuestas contra `main`, los cambios integrados y las ejecuciones
manuales.

## Activar la comprobación local

Instala `pre-commit` en tu entorno de desarrollo y registra los hooks del
repositorio:

```bash
pipx install pre-commit
pre-commit install
pre-commit run --all-files
```

El hook analiza únicamente los cambios preparados para el commit. No envía el
contenido del repositorio a ningún servicio externo. La comprobación de GitHub
Actions analiza el historial necesario para detectar un secreto añadido y
eliminado dentro de la misma rama.

## Si Gitleaks bloquea un cambio

1. Si es una credencial real, revócala o rótala de inmediato. Eliminarla del
   archivo no basta porque puede haber quedado en el historial.
2. Elimina la credencial del cambio y obténla en ejecución desde Vaultwarden o
   GNOME Keyring según corresponda.
3. Ejecuta `pre-commit run --all-files` antes de volver a preparar el commit.

Los hallazgos se muestran redactados; no copies valores detectados a incidencias,
mensajes de commit ni documentación.

## Falsos positivos

No desactives el hook ni excluyas reglas completas. Si una detección es un
falso positivo, registra una excepción mínima y revisable en la configuración
de Gitleaks, con una justificación que no incluya el valor detectado. La
excepción debe identificar solo el fichero y la huella que produzca Gitleaks.
