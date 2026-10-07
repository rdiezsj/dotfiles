# Spec Delta

## Purpose

Gestiona un conjunto esencial de extensiones GNOME de forma reproducible, con
fuentes mantenidas y compatibles con la versión de GNOME Shell de Fedora.

## ADDED Requirements

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

### Requirement: Activación idempotente
El sistema SHALL activar mediante el UUID declarado cada extensión instalada
que aún no esté activa. Tras cada activación SHALL comprobar que GNOME Shell la
reconoce; si la sesión requiere recarga, SHALL comunicar que se cierre e inicie
sesión manualmente sin reiniciar el equipo ni GNOME Shell automáticamente.

#### Scenario: Extensión instalada pero inactiva
- **WHEN** una extensión declarada está disponible y no figura como activa
- **THEN** el bootstrap la activa para el usuario actual y registra el resultado

#### Scenario: Recarga de sesión requerida
- **WHEN** GNOME Shell no aplica una extensión recién activada en la sesión actual
- **THEN** el resumen informa de que la persona debe cerrar e iniciar sesión manualmente
