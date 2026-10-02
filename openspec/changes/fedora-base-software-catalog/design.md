# Design

## Context

Los catálogos existentes están vacíos y el bootstrap ya habilita RPM Fusion Free y Nonfree, Homebrew y Flatpak. Véanse `proposal.md` y las especificaciones para el alcance funcional.

## Goals / Non-Goals

**Goals:**

- Ejecutar listas declarativas reproducibles, con estado por elemento y sin reinstalaciones innecesarias.
- Resolver sustituciones de aplicaciones antes de instalar su alternativa aprobada.
- Aislar la lógica Fedora, las fuentes externas y las acciones que requieren reinicio o intervención humana.
- Descargar AppImage con versiones y sumas fijadas, manteniendo `~/Apps` como destino de Gear Lever.

**Non-Goals:**

- Instalar fórmulas Homebrew de Zsh, configurar Zsh, Starship, plugins o herramientas Kubernetes.
- Automatizar la configuración detallada de Terminator, input-remapper, Heynote, Gear Lever, Flameshot u otras aplicaciones; sus ajustes versionables se tratarán en un cambio específico y nunca se copiarán desde un equipo existente.
- Configurar cuentas, dispositivos, carpetas sincronizadas o credenciales de Syncthing.
- Omitir el enrolamiento MOK de Secure Boot ni automatizar acciones de firmware.

## Decisions

### Ejecutores por gestor y catálogos con identificadores

Cada catálogo conservará el identificador real del gestor, la finalidad en español y, para AppImage, versión, URL y SHA-256. Los ejecutores consultarán primero el estado, mostrarán el plan y aplicarán solo las diferencias.

Alternativa descartada: un catálogo único de nombres de aplicaciones. Impediría identificar de forma estable paquetes DNF, IDs Flatpak y archivos AppImage.

### Sustituciones como operaciones declaradas

Firefox y la suite ofimática se modelarán como grupos exclusivos: retirar variantes no aprobadas, instalar la alternativa elegida y volver a verificar el estado. El plan mostrará las desinstalaciones antes de aplicarlas.

Alternativa descartada: instalar la alternativa sin retirar las demás. Mantendría duplicidades y asociaciones de archivos ambiguas.

### Fuentes externas verificadas

VS Code usará el repositorio RPM oficial de Microsoft. RPM Fusion aportará FFmpeg completo, codecs, DVD y NVIDIA; la fuente tainted de DVD se declarará solo si puede validarse. Ninguna URL, clave o checksum se aceptará dinámicamente sin estar declarada.

Alternativa descartada: descargar RPM individuales o ejecutables sin metadatos firmados. Perdería actualizaciones DNF y trazabilidad.

### NVIDIA y Secure Boot

La detección se basará en `lspci`, no en el modelo anotado por la persona usuaria. La RTX 4060 Ti es compatible con el conjunto moderno `akmod-nvidia`; el mismo conjunto se aplicará únicamente si el equipo lo necesita. Tras instalar se comprobará la compilación de akmods y se marcará reinicio; con Secure Boot se explicará y esperará el enrolamiento MOK antes de validar `nvidia-smi`.

Alternativa descartada: instalar NVIDIA en todos los equipos o desactivar Secure Boot. Ambas opciones degradan compatibilidad o seguridad.

### Syncthing como unidad de usuario

Se habilitará `systemctl --user` para que Syncthing use el HOME del usuario. Se solicitará activar linger solo si se desea que continúe sin sesión iniciada; por defecto no se modifica esa política.

Alternativa descartada: un servicio global ejecutado como root. Complica permisos y no corresponde al propietario de los archivos sincronizados.

## Risks / Trade-offs

- [Cambios de nombres o disponibilidad entre Fedora 44 y repositorios] → verificar cada identificador y fuente en ejecución, y fallar por elemento sin ocultarlo.
- [Las sustituciones pueden retirar software con datos locales] → mostrar plan y requerir la confirmación global ya existente; no borrar perfiles ni datos de usuario.
- [Módulo NVIDIA aún compilando o Secure Boot activo] → no validar el driver hasta reinicio y enrolamiento MOK cuando corresponda.
- [AppImage sin suma oficial] → no descargarlo automáticamente; mantenerlo pendiente hasta declarar una suma verificable.

## Migration Plan

1. Actualizar el checkout y ejecutar simulación para revisar paquetes, sustituciones y detección de hardware.
2. Ejecutar en una VM Fedora con y sin GPU NVIDIA; verificar no-op en el caso sin NVIDIA.
3. Verificar tras reinicio el controlador NVIDIA, codecs y servicio de Syncthing.
4. Reejecutar el bootstrap y comprobar idempotencia y ausencia de aplicaciones excluidas.
