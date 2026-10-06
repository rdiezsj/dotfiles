# Spec Delta

## MODIFIED Requirements

### Requirement: Controlador NVIDIA condicionado por hardware
El sistema SHALL detectar una GPU NVIDIA compatible mediante el inventario PCI y SHALL gestionar exclusivamente la pila propietaria RPM Fusion declarada: `akmod-nvidia`, soporte CUDA y bibliotecas VA-API NVIDIA de 64 y 32 bits. Antes de instalar o reparar, SHALL comprobar que esos paquetes y el módulo del kernel activo son conformes; no reinstalará una pila ya verificada.

#### Scenario: RTX 4060 Ti detectada
- **WHEN** el inventario PCI identifica una NVIDIA GeForce RTX 4060 Ti y falta un paquete esperado o el módulo para el kernel activo
- **THEN** el sistema instala o repara solo los componentes faltantes desde RPM Fusion y espera de forma acotada la compilación de akmods

#### Scenario: Pila RPM Fusion ya operativa
- **WHEN** la GPU NVIDIA compatible, los paquetes declarados, el módulo del kernel activo y `nvidia-smi` están disponibles
- **THEN** el sistema registra el controlador propietario como presente y no ejecuta una reinstalación ni una compilación innecesaria

#### Scenario: Reinicio necesario para validar la carga
- **WHEN** la compilación para el kernel activo termina pero `nvidia-smi` no puede confirmar el controlador en la sesión actual
- **THEN** el sistema no reinicia ni se reejecuta por su cuenta, registra que la persona debe reiniciar manualmente y ejecutar manualmente `./bootstrap`, y en esa ejecución posterior valida automáticamente la pila

#### Scenario: Equipo sin GPU NVIDIA
- **WHEN** el inventario PCI no identifica una GPU NVIDIA compatible
- **THEN** el sistema omite el controlador NVIDIA sin modificar los controladores gráficos existentes

### Requirement: Secure Boot explícito
El sistema SHALL detectar Secure Boot antes de finalizar una instalación NVIDIA. Si impide cargar el módulo, SHALL informar del enrolamiento MOK requerido, no declarará el controlador operativo y conservará la validación automática para una ejecución posterior a dicho enrolamiento.

#### Scenario: Secure Boot habilitado
- **WHEN** Secure Boot está habilitado y el módulo NVIDIA no puede cargarse
- **THEN** el sistema informa de la intervención MOK necesaria, no reinicia ni se reejecuta por su cuenta y no declara operativo el controlador

#### Scenario: Secure Boot completado y bootstrap reejecutado
- **WHEN** la persona ha enrolado la clave MOK, ha reiniciado y vuelve a ejecutar el bootstrap
- **THEN** el sistema valida automáticamente el módulo y `nvidia-smi` antes de declarar operativo el controlador
