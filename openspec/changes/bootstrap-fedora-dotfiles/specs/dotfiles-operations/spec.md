# Spec Delta

## Purpose

Ofrece un bootstrap seguro, simulable e idempotente con comunicación clara en español y sin exponer secretos.

## ADDED Requirements

### Requirement: Plan y confirmación previos
El sistema SHALL ofrecer una simulación o comprobación previa y SHALL mostrar un plan legible antes de modificar el equipo; la aplicación requerirá confirmación humana.

#### Scenario: Simulación sin cambios
- **WHEN** se solicita el modo de simulación
- **THEN** el sistema informa de acciones y conflictos sin instalar ni modificar archivos

#### Scenario: Plan confirmado
- **WHEN** el plan no contiene conflictos bloqueantes y la persona confirma
- **THEN** el bootstrap aplica únicamente las acciones mostradas

### Requirement: Interfaz progresiva en español
El sistema SHALL usar Gum cuando esté disponible y SHALL usar salida Bash clara y legible hasta que Gum se instale; todos los mensajes, scripts y comentarios estarán en español.

#### Scenario: Gum ausente al inicio
- **WHEN** `gum` aún no está instalado
- **THEN** el bootstrap muestra el plan y las intervenciones humanas mediante salida Bash legible

### Requirement: Idempotencia y resumen final
El sistema SHALL evitar reinstalar o sobrescribir elementos ya conformes y SHALL finalizar con un resumen de instalados, ya presentes, omitidos, fallidos y acciones manuales pendientes.

#### Scenario: Segunda ejecución conforme
- **WHEN** el bootstrap se ejecuta de nuevo sobre un estado conforme
- **THEN** el resumen comunica los elementos ya presentes y no realiza cambios innecesarios

### Requirement: Diagnóstico sin secretos
Las operaciones SHALL emitir diagnósticos sin incluir contraseñas, tokens, sesiones ni valores procedentes de Vaultwarden o GNOME Keyring.

#### Scenario: Fallo de una operación de secretos
- **WHEN** una operación falla por una sesión de Vaultwarden inválida
- **THEN** el diagnóstico identifica el estado de sesión sin mostrar su valor
