# vaultwarden-session Specification

## Purpose

Integra Vaultwarden mediante Bitwarden CLI como origen de secretos y conserva una sesión revocable en GNOME Keyring sin versionar credenciales.

## Requirements

### Requirement: Fase de secretos no bloqueante
El bootstrap base SHALL instalar Bitwarden CLI como dependencia de la fase de secretos y SHALL poder completarse sin acceder a Vaultwarden; la configuración del servidor y el inicio de sesión serán una fase final cancelable.

#### Scenario: Vaultwarden no disponible
- **WHEN** la persona cancela el inicio de sesión o el servidor no está disponible
- **THEN** el bootstrap base finaliza y las operaciones que requieren secretos comunican que falta una sesión válida

#### Scenario: Bitwarden CLI ausente
- **WHEN** comienza la fase de secretos y `bw` no está disponible
- **THEN** el bootstrap instala Bitwarden CLI mediante Homebrew antes de solicitar la URL de Vaultwarden

### Requirement: Configuración explícita del servidor
El sistema SHALL aceptar la URL de Vaultwarden de forma interactiva o mediante `--vault-server` y SHALL evitar versionarla en el repositorio.

#### Scenario: Configuración interactiva
- **WHEN** se inicia la fase de secretos sin `--vault-server`
- **THEN** el sistema solicita la URL antes de iniciar sesión en `bw`

### Requirement: Sesión persistente sin contraseña maestra
El sistema SHALL solicitar la contraseña maestra únicamente a la interfaz interactiva de `bw`, SHALL almacenar solo una sesión revocable en GNOME Keyring y SHALL validarla antes de reutilizarla en un shell nuevo.

#### Scenario: Sesión válida tras abrir una terminal nueva
- **WHEN** existe una sesión válida en GNOME Keyring
- **THEN** una terminal nueva puede validar y usar `bw` sin solicitar de nuevo la contraseña maestra

#### Scenario: Sesión ausente o inválida
- **WHEN** no existe una sesión válida en GNOME Keyring
- **THEN** el sistema no expone ningún secreto y solicita configurar o desbloquear `bw`
