# fedora-multimedia-nvidia Specification

## Purpose

Amplía una Fedora compatible con codecs multimedia y controladores NVIDIA de RPM Fusion, sin aplicar controladores a equipos que no los necesitan.

## Requirements

### Requirement: Pila multimedia RPM Fusion
El sistema SHALL sustituir la variante limitada de FFmpeg por la completa, instalar el grupo multimedia y los códecs de audio, vídeo y DVD disponibles desde las fuentes RPM Fusion declaradas.

#### Scenario: Fedora con RPM Fusion configurado
- **WHEN** se ejecuta el catálogo multimedia en un equipo compatible
- **THEN** quedan disponibles FFmpeg completo y los códecs declarados sin conservar la variante limitada incompatible

#### Scenario: Fuente DVD no disponible
- **WHEN** el soporte DVD requiere una fuente RPM Fusion que no puede validarse
- **THEN** el sistema no instala un paquete de origen alternativo y registra la acción como pendiente

### Requirement: Controlador NVIDIA condicionado por hardware
El sistema SHALL detectar una GPU NVIDIA mediante el inventario PCI y SHALL instalar `akmod-nvidia`, soporte CUDA y bibliotecas VA-API NVIDIA de 64 y 32 bits solo en equipos donde se detecte hardware NVIDIA compatible.

#### Scenario: RTX 4060 Ti detectada
- **WHEN** el inventario PCI identifica una NVIDIA GeForce RTX 4060 Ti
- **THEN** el sistema instala el conjunto de controlador declarado y deja indicada la verificación posterior al reinicio

#### Scenario: Equipo sin GPU NVIDIA
- **WHEN** el inventario PCI no identifica una GPU NVIDIA
- **THEN** el sistema omite el controlador NVIDIA sin modificar los controladores gráficos existentes

### Requirement: Secure Boot explícito
El sistema SHALL detectar Secure Boot antes de finalizar una instalación NVIDIA y SHALL informar de la intervención de enrolamiento MOK necesaria cuando el módulo no pueda cargarse sin ella.

#### Scenario: Secure Boot habilitado
- **WHEN** Secure Boot está habilitado durante la instalación NVIDIA
- **THEN** el sistema no declara el controlador operativo hasta que la persona complete y verifique el enrolamiento MOK
