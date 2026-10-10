# Spec Delta

## Purpose

Detectar diferencias entre la configuración declarada de los dotfiles y el estado de la estación mediante comprobaciones locales de solo lectura.

## ADDED Requirements

### Requirement: Comando de diagnóstico sin efectos secundarios
El sistema SHALL ofrecer `dotfiles doctor` y una invocación directa desde el checkout. SHALL limitarse a lecturas locales sin red, sudo, reparaciones, instalaciones, escrituras de caché ni consulta de credenciales. Los argumentos desconocidos SHALL devolver 2 y mostrar el uso sin iniciar comprobaciones.

#### Scenario: Ejecución repetida
- **WHEN** se ejecuta dos veces el diagnóstico sobre la misma configuración
- **THEN** conserva archivos, enlaces y preferencias y emite el mismo informe

#### Scenario: Secretos disponibles
- **WHEN** hay identidad personal o credenciales locales
- **THEN** no muestra nombre, correo, tokens, sesiones ni contenido privado ni invoca Bitwarden o secret-tool

#### Scenario: Invocación no admitida
- **WHEN** se solicita un subcomando no admitido o un argumento desconocido
- **THEN** informa del uso, termina con 2 y no ejecuta comprobaciones

### Requirement: Diagnóstico de enlaces declarados
El diagnóstico SHALL leer los enlaces declarados en `install.conf.yaml` del checkout seleccionado y comprobar que cada destino sea un enlace válido al origen esperado. SHALL identificar ausencia, enlace roto, destino ajeno y origen ausente como deriva sin sobrescribirlos. Una declaración ilegible o no admitida SHALL producir no comprobado.

#### Scenario: Destinos conformes
- **WHEN** los enlaces declarados apuntan al origen esperado existente
- **THEN** se informan como conformes, incluidos enlaces a directorios y rutas con espacios

#### Scenario: Destino local o enlace incorrecto
- **WHEN** un destino está ausente, es un archivo local o apunta a otro origen
- **THEN** identifica la ruta afectada y una orientación para revisar el conflicto o reejecutar el bootstrap

#### Scenario: Submódulo o declaración no disponible
- **WHEN** no se puede interpretar la declaración por falta del lector o por formato inválido
- **THEN** informa de comprobación no disponible sin inicializar submódulos y continúa las comprobaciones independientes

### Requirement: Estado local requerido
El diagnóstico SHALL comprobar que la identidad Git global tenga nombre y correo, que un archivo de identidad local existente sea regular y tenga permisos privados, y que existan los perfiles locales base y resaltado de Sheldon en XDG_DATA_HOME. SHALL verificar los valores de Ptyxis frente a su configuración declarada mediante lecturas locales; si no puede consultarlos, SHALL informar no comprobado.

#### Scenario: Identidad ausente o permisos abiertos
- **WHEN** falta parte de la identidad global o el archivo local permite acceso a otros usuarios
- **THEN** señala la incidencia sin imprimir sus valores

#### Scenario: Plugins pendientes
- **WHEN** falta un lockfile Sheldon de alguno de los dos perfiles
- **THEN** identifica el perfil pendiente sin resolver ni descargar plugins

#### Scenario: Preferencia aplicada diferente
- **WHEN** un valor de Ptyxis difiere del archivo versionado
- **THEN** informa de la clave afectada como deriva sin cambiarla

#### Scenario: Sesión sin consulta disponible
- **WHEN** dconf no existe, falla o excede el tiempo límite
- **THEN** informa no comprobado, sin confundirlo con una preferencia conforme

### Requirement: Informe y estado de salida
El diagnóstico SHALL emitir resultados y resumen en español con estados conforme, deriva y no comprobado, junto con orientación manual cuando corresponda. SHALL devolver 1 si hay deriva, 2 si solo hay comprobaciones no disponibles y 0 si todo es conforme. Los fallos individuales SHALL permitir continuar con las comprobaciones independientes.

#### Scenario: Diagnóstico conforme
- **WHEN** todas las comprobaciones terminan y coinciden con lo declarado
- **THEN** devuelve 0 y resume los resultados conformes

#### Scenario: Deriva con diagnóstico parcial
- **WHEN** existe deriva aunque otra comprobación no esté disponible
- **THEN** devuelve 1 y enumera también las comprobaciones pendientes

#### Scenario: Diagnóstico incompleto sin deriva observada
- **WHEN** no hay deriva observada pero una comprobación no está disponible
- **THEN** devuelve 2 y explica qué no pudo comprobar
