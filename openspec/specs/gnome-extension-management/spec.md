# gnome-extension-management Specification

## Purpose

Gestiona un conjunto esencial de extensiones GNOME de forma reproducible, con
fuentes mantenidas y compatibles con la versión de GNOME Shell de Fedora.

## Requirements

### Requirement: Bloque de extensiones GNOME separado
El bootstrap SHALL presentar y ejecutar un bloque «Extensiones GNOME» después
del catálogo de software. SHALL instalar y activar AppIndicator, Custom Hot
Corners Extended, Clipboard Indicator, Vitals y Dash to Dock para el usuario
que ejecuta el bootstrap, sin modificar otras extensiones ni sus preferencias.

#### Scenario: Estación nueva compatible
- **WHEN** el catálogo de software termina en una estación Fedora GNOME compatible
- **THEN** el bootstrap procesa el bloque de extensiones GNOME y registra el resultado de cada extensión

#### Scenario: Segunda ejecución conforme
- **WHEN** las cinco extensiones ya están instaladas y activas
- **THEN** el bootstrap las comunica como presentes sin reinstalarlas ni alterar sus preferencias

### Requirement: Origen mantenible por extensión
El sistema SHALL instalar AppIndicator y Dash to Dock desde DNF. SHALL obtener
Custom Hot Corners Extended, Clipboard Indicator y Vitals exclusivamente desde
extensions.gnome.org, seleccionando una publicación compatible con la versión
de GNOME Shell instalada. SHALL NOT clonar repositorios Git, compilar código ni
configurar COPR para estas extensiones.

#### Scenario: Publicación compatible disponible
- **WHEN** extensions.gnome.org publica una versión compatible de una extensión declarada
- **THEN** el bootstrap instala esa publicación para el usuario sin usar una fuente alternativa

#### Scenario: Publicación compatible no disponible
- **WHEN** no existe una publicación compatible con la versión de GNOME Shell instalada
- **THEN** el bootstrap conserva el estado existente de esa extensión y registra el fallo con su nombre y UUID

### Requirement: Activación idempotente y diferida
El sistema SHALL activar mediante el UUID declarado cada extensión instalada
que aún no esté activa. Tras cada activación SHALL comprobar que GNOME Shell la
reconoce. Si una extensión recién instalada no está disponible todavía para
activarse, SHALL comunicar una nueva sesión GNOME como acción pendiente, sin
reiniciar el equipo ni GNOME Shell automáticamente ni declarar fallida la fase.
El resumen final SHALL incluir el comando `activar-extensiones-gnome` como el
siguiente paso y no SHALL listar esa extensión ni la fase en «Fallidos».

#### Scenario: Extensión instalada pero inactiva
- **WHEN** una extensión declarada está disponible y no figura como activa
- **THEN** el bootstrap la activa para el usuario actual y registra el resultado

#### Scenario: Activación diferida hasta una nueva sesión
- **WHEN** una extensión recién instalada no se puede activar todavía en la sesión actual
- **THEN** el resumen final la registra solo como acción pendiente, indica cerrar e iniciar sesión y ejecutar `activar-extensiones-gnome`, y no marca fallida la extensión ni la fase

### Requirement: Comprobación posterior de activación
El sistema SHALL ofrecer el alias `activar-extensiones-gnome` para activar y
verificar exclusivamente las extensiones declaradas en una nueva sesión GNOME.
SHALL informar el nombre y UUID de cada extensión que continúe sin poder
activarse y terminar con error, sin reinstalar, actualizar ni modificar
preferencias.

#### Scenario: Nueva sesión con extensiones disponibles
- **WHEN** la persona inicia una nueva sesión GNOME y ejecuta `activar-extensiones-gnome`
- **THEN** el comando activa las extensiones declaradas inactivas, comunica las ya activas y termina correctamente

#### Scenario: Fallo persistente tras una nueva sesión
- **WHEN** `activar-extensiones-gnome` no puede activar una extensión declarada desde una nueva sesión GNOME
- **THEN** el comando comunica su nombre y UUID, termina con error y conserva las restantes extensiones y preferencias
