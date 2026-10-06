# Spec Delta

## MODIFIED Requirements

### Requirement: Idempotencia y resumen final
El sistema SHALL evitar reinstalar o sobrescribir elementos ya conformes y SHALL finalizar con un resumen de instalados, ya presentes, omitidos, fallidos y acciones manuales pendientes reales; no incluirá marcadores genéricos de fases ya ejecutadas. Para NVIDIA, el resumen SHALL distinguir una pila propietaria verificada, una compilación en curso o fallida y, si procede, indicará explícitamente que la persona debe reiniciar y ejecutar manualmente `./bootstrap` para comprobarla.

#### Scenario: Segunda ejecución conforme
- **WHEN** el bootstrap se ejecuta de nuevo tras completar la compilación o el reinicio requerido y la pila NVIDIA queda operativa
- **THEN** el resumen comunica que el controlador está verificado y no realiza cambios innecesarios

#### Scenario: Reinicio pendiente de validación NVIDIA
- **WHEN** la comprobación NVIDIA no puede completarse en la sesión actual por requerir un reinicio
- **THEN** el resumen registra exclusivamente que la persona debe reiniciar y ejecutar manualmente `./bootstrap`, sin presentar `nvidia-smi` como una comprobación manual separada
