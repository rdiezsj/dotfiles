# Tasks

## 1. Detector y comprobación local

- [x] 1.1 Añadir la configuración versionada de Gitleaks, incluidas únicamente excepciones justificadas sin secretos, y verificar que su análisis del árbol actual finaliza correctamente.
- [x] 1.2 Configurar el hook `pre-commit` versionado para analizar los cambios preparados y verificar que se instala y ejecuta sobre un cambio de prueba seguro.
- [x] 1.3 Añadir pruebas automatizadas de la configuración y del hook, verificando tanto el caso limpio como el rechazo de una detección sintética sin mostrar su valor.
- [x] 1.4 Documentar la instalación del hook, la corrección de detecciones y el proceso de excepción, y verificar los enlaces con la comprobación documental existente.

## 2. Integración continua

- [x] 2.1 Crear el flujo de GitHub Actions para analizar secretos en propuestas contra `main`, cambios en `main` y ejecuciones manuales, y verificar su sintaxis y disparadores.
- [x] 2.2 Fijar las referencias de acciones y del detector, asegurar que el flujo obtiene el historial necesario y verificar que una detección sintética hace fallar el análisis sin exponer el valor.
- [x] 2.3 Ejecutar la suite unitaria, las comprobaciones de documentación y `openspec validate prevent-versioned-secrets --strict`, corrigiendo cualquier fallo atribuible al cambio.
