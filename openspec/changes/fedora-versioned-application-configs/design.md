# Design

## Context

El repositorio ya usa Dotbot para archivos de shell y conserva el destino si no
está gestionado. El catálogo DNF contiene Terminator, `vim-enhanced` e Input
Remapper, mientras que Gear Lever se instala como Flatpak y Heynote como
AppImage. Ver `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**

- Mantener una única fuente versionada para preferencias portables.
- Aplicar configuraciones mediante enlaces declarativos y comprobables.
- Instalar los paquetes DNF necesarios sin nuevos repositorios externos.
- Diferenciar una configuración base aplicable de una plantilla personal aún
  pendiente.

**Non-Goals:**

- No convertir Vaultwarden en un requisito del bootstrap ni crear un servicio
  de envío de correo.
- No copiar notas o buffers de Heynote ni estado del sandbox de Gear Lever.
- No activar un preset de Input Remapper para un hardware no identificado.
- No configurar atajos de GNOME para Flameshot ni una interfaz gráfica para
  Vim; esa evaluación queda aplazada.

## Decisions

### Archivos concretos frente a directorios de aplicación

Dotbot declarará archivos específicos: `.nanorc`, `.vimrc`, `.gitconfig`,
`.gitignore`, `flameshot.ini`, la configuración de Terminator, `config.json` y
`Preferences` de Heynote, y la raíz controlada de Input Remapper 2. No enlazará
árboles de perfiles completos.

Esto conserva la política actual de conflictos y evita incorporar cachés,
sesiones, buffers y registros. Como alternativa se valoró enlazar
`~/.config/<aplicación>` completo; se descarta porque Gear Lever e Heynote
mezclan configuración con datos locales.

### Preferencias aún no decididas como configuración base y plantilla

Nano, Vim y Flameshot recibirán una configuración funcional que omite valores
personales no decididos. Los puntos de extensión quedarán documentados en el
propio archivo o en una plantilla versionada, sin introducir texto inválido en
la configuración activa. msmtp tendrá un fichero skeleton versionado y
enlazado, pero sin una cuenta SMTP configurada.

Así el bootstrap sigue siendo no interactivo para esos valores. Pedirlos en
cada instalación se descarta porque contradice la mínima intervención humana;
usar valores inventados se descarta porque cambiaría preferencias personales.

### Cuenta IONOS y consulta diferida de Vaultwarden

La configuración activa de msmtp declarará el host, puerto, remitente y TLS de
IONOS. El usuario se resolverá mediante `eval` y la contraseña mediante
`passwordeval`; ambos helpers consultarán el ítem exacto `Mail.ionos.es` con la
sesión almacenada en GNOME Keyring. Los helpers escribirán diagnósticos solo en
stderr y devolverán en stdout únicamente el valor que msmtp consume.

Vaultwarden no será obligatorio: una sesión ausente impide enviar correo, pero
no invalida el bootstrap. Hacer obligatorio el login se descarta porque añade
una intervención ajena a la preparación base de la estación.

### Input Remapper declarativo, sin autoload inicial

La configuración base tendrá un autoload vacío y los presets versionados serán
optativos. Una persona podrá completar la asociación tras identificar el
dispositivo real. El servicio de Input Remapper se habilitará solo cuando la
configuración base haya sido aplicada correctamente, sin que ello active una
asociación de hardware.

### Gear Lever como plantilla de configuración curada

Se añadirá una plantilla documentada para la configuración de Gear Lever, no
un enlace al directorio Flatpak. Antes de promover una preferencia a
configuración activa se verificará en una instalación real que no contiene
inventario de AppImages ni rutas de equipo.

## Risks / Trade-offs

- [Valores de tabulación y captura sin decidir] → La configuración base no los
  fija y deja una plantilla explícita para completarlos en un cambio posterior.
- [Configuración de Heynote cambia entre versiones AppImage] → Se enlazan solo
  los dos archivos confirmados y una prueba verifica sus rutas exactas.
- [Preset Input Remapper no portable] → El autoload queda vacío y el servicio
  no se asocia a dispositivos de forma automática.
- [Vaultwarden bloqueado al enviar] → Los helpers fallan sin exponer secretos y
  muestran la acción para iniciar o desbloquear una sesión válida.
- [Archivo de log no escribible] → Se usa `~/.local/state/msmtp/msmtp.log` y
  se crea su directorio de estado de usuario bajo demanda.
- [Tema de Gear Lever no estable] → Se conserva como plantilla no aplicada
  hasta verificar su formato y ausencia de estado local.

## Migration Plan

1. Añadir los archivos fuente y las entradas Dotbot sin forzar enlaces.
2. Añadir paquetes DNF y la habilitación condicionada de Input Remapper.
3. Ejecutar pruebas unitarias de catálogo, conflicto y enlaces declarados.
4. Probar el bootstrap en Fedora nueva y confirmar que una segunda ejecución
   no modifica configuraciones ya gestionadas.

Para revertir, se eliminarán exclusivamente las entradas de Dotbot y los
archivos versionados añadidos; los destinos locales no gestionados seguirán sin
tocarse. Los paquetes DNF no se desinstalarán automáticamente.
