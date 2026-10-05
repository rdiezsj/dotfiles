# archive-utilities Specification

## Purpose

Proporciona extracción directa y compresión guiada para archivos y carpetas desde Zsh.

## ADDED Requirements

### Requirement: Extracción directa
La función `extract` SHALL aceptar un archivo comprimido compatible, detectar su formato y extraerlo en un destino seguro sin borrar el original ni sobrescribir archivos existentes sin confirmación explícita.

#### Scenario: Archivo compatible
- **WHEN** se ejecuta `extract` sobre un archivo tar, zip o 7z válido
- **THEN** crea o utiliza el directorio de destino y muestra un resumen de los archivos extraídos

#### Scenario: Archivo no compatible
- **WHEN** la ruta no existe o el formato no está soportado
- **THEN** termina con error legible sin crear ni modificar archivos

### Requirement: Compresión guiada
El comando `compress` SHALL usar Gum cuando esté disponible para solicitar formato, destino, tamaño de bloque y opciones sencillas aplicables. SHALL admitir como mínimo `tar.gz`, `tar.xz`, `zip` y `7z`, aceptar archivos o carpetas, no borrar los originales y rechazar la sobrescritura por defecto.

#### Scenario: Compresión interactiva
- **WHEN** se ejecuta `compress` en una terminal con Gum disponible
- **THEN** muestra un asistente breve, crea el archivo elegido y resume la operación

#### Scenario: Gum no disponible
- **WHEN** se ejecuta `compress` sin Gum
- **THEN** usa preguntas Bash equivalentes en una terminal interactiva o termina con un mensaje accionable si no hay terminal

### Requirement: División y recomposición
Cuando se selecciona división por bloques, `compress` SHALL generar partes numeradas sin eliminar el archivo fuente y SHALL mostrar el comando para recomponerlas antes de extraerlas.

#### Scenario: Archivo dividido
- **WHEN** la persona usuaria selecciona un tamaño de bloque
- **THEN** crea las partes en el destino elegido y muestra cómo unirlas con `cat` antes de usar `extract`

#### Scenario: Salida existente
- **WHEN** el archivo o alguna parte de salida ya existe
- **THEN** solicita confirmación explícita y conserva la salida existente si se rechaza
