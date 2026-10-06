# Design

## Context

La fase actual detecta el fabricante NVIDIA con PCI e instala siempre un único
conjunto de paquetes. El resultado se declara pendiente sin comprobar el
módulo construido para el kernel actual ni la comunicación con el driver.
Véase `proposal.md` para la motivación y las deltas de especificación para el
contrato observable.

## Goals / Non-Goals

**Goals:**

- Mantener RPM Fusion nonfree y `akmod-nvidia` como única vía de controlador
  propietario gestionada.
- Comprobar el estado antes de actuar, instalar únicamente componentes no
  conformes y verificar de manera automática la compilación y disponibilidad
  del driver.
- Permitir que una segunda ejecución manual tras reinicio complete la
  certificación sin repetir instalaciones.

**Non-Goals:**

- Instalar el ejecutable `.run`, el repositorio CUDA de NVIDIA o un driver
  alternativo.
- Reiniciar automáticamente, modificar Secure Boot o automatizar el
  enrolamiento MOK.
- Dar soporte a hardware NVIDIA no compatible con la rama declarada por RPM
  Fusion.

## Decisions

### RPM Fusion akmods como fuente y mecanismo únicos

La validación comprobará el conjunto declarado de paquetes RPM Fusion y el
módulo `nvidia` correspondiente a `uname -r`. `akmod-nvidia` mantiene el
módulo alineado con los kernels Fedora y proporciona la ruta empaquetada para
el driver propietario, CUDA y las bibliotecas de usuario.

Alternativa descartada: instalador `.run` de NVIDIA. Puede sobrescribir o
desacoplar componentes gestionados por DNF y no ofrece la integración con el
ciclo de kernels que necesita el bootstrap.

### Máquina de estados local y repetible

La fase clasificará el equipo como: sin GPU NVIDIA compatible, pila operativa,
paquetes o módulo incompletos, compilación de akmods fallida o pendiente de
reinicio/validación. Solo los estados incompletos ejecutarán DNF o akmods. La
validación final combinará paquete, módulo para el kernel actual y
`nvidia-smi`; por tanto, no equivale a que el binario esté simplemente
instalado.

Alternativa descartada: marcar como correcto solo porque `rpm -q
akmod-nvidia` tiene éxito. No prueba que haya un módulo utilizable ni que el
driver esté cargado.

### Espera acotada y reejecución manual

Tras cambios que requieren compilar, el bootstrap invocará la comprobación de
akmods y esperará durante un plazo finito, consultando el estado del módulo.
Si no puede validar `nvidia-smi` en la sesión actual pero el artefacto del
kernel está construido, el resumen pedirá que la persona reinicie y vuelva a
ejecutar manualmente `./bootstrap`. La siguiente ejecución manual solo
comprobará el estado y no reinstalará paquetes conformes.

Alternativa descartada: reinicio automático. Interrumpiría trabajo de la
persona usuaria y no resolvería el enrolamiento MOK de Secure Boot.

## Risks / Trade-offs

- [La compilación puede superar el plazo] → registrar el fallo o pendiente
  verificable y no declarar operativo el driver.
- [La sesión gráfica actual puede conservar Nouveau u otro módulo] → requerir
  reinicio manual y revalidar automáticamente en la siguiente ejecución
  manual.
- [Secure Boot bloquea un módulo compilado] → indicar solo el enrolamiento MOK
  necesario y conservar el estado pendiente hasta que `nvidia-smi` funcione.
- [Una GPU antigua necesita una rama legacy] → no instalar a ciegas; informar
  de incompatibilidad y preservar el driver actual.

## Migration Plan

1. Añadir comprobaciones y pruebas con dobles de PCI, RPM, akmods, módulo y
   `nvidia-smi`.
2. Sustituir el mensaje genérico de pendiente por estados comprobados y la
   instrucción de reiniciar y reejecutar manualmente tras el reinicio.
3. Actualizar las guías NVIDIA preservando los cambios existentes del README.
4. Ejecutar la suite afectada y una segunda simulación para demostrar que el
   estado conforme no ejecuta operaciones mutantes.
