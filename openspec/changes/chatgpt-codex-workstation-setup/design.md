# Design

## Context

El catálogo actual instala aplicaciones DNF por nombre, CLI Homebrew mediante `brew list --versions`, y los enlaces personales mediante Dotbot. OpenAI publica ChatGPT para Fedora como RPM por arquitectura y mantiene el repositorio de actualización firmado tras la instalación. OpenSpec 1.14.0 ya está instalado globalmente en este equipo por npm; la fórmula Homebrew `openspec` existe y declara Node como dependencia. El perfil actual de Codex contiene `AGENTS.md` y un árbol `skills/` de 55 ficheros, incluidos recursos bajo `.system/`.

## Goals / Non-Goals

**Goals:**

- Instalar ChatGPT en Fedora compatible mediante el paquete y los canales oficiales, con soporte x86_64 y aarch64.
- Proporcionar OpenSpec como CLI global, reconociendo antes una instalación global funcional para no duplicarla.
- Capturar y enlazar el contenido completo actual de `~/.codex/AGENTS.md` y `~/.codex/skills/`, conservando rutas ocultas y recursos anidados.
- Hacer migrables destinos Codex existentes con confirmación y respaldo recuperable.

**Non-Goals:**

- Gestionar la autenticación de ChatGPT, sus datos locales, `~/.codex/config.toml`, cachés, plugins, marketplaces o estado de conversaciones.
- Instalar Codex CLI por separado: el objetivo es ChatGPT Desktop con Codex integrado.
- Instalar OpenSpec como dependencia de cada proyecto ni actualizar automáticamente una instalación global ya funcional.

## Decisions

1. **ChatGPT se instala desde el RPM oficial de OpenAI.** Seleccionar según `uname -m` entre `https://persistent.oaistatic.com/codex-app-prod/linux/rpm/latest/chatgpt.x86_64.rpm` y `https://persistent.oaistatic.com/codex-app-prod/linux/rpm/latest/chatgpt.aarch64.rpm`, instalar mediante DNF y comprobar el paquete `chatgpt`. Saltar con un motivo claro en releases Fedora o arquitecturas que OpenAI no declare compatibles. El RPM prepara el repositorio firmado usado para posteriores actualizaciones; no se añadirá un Flatpak de terceros.

2. **OpenSpec queda como herramienta CLI global de Homebrew.** Declarar la fórmula oficial `openspec` en el catálogo Homebrew. Antes de instalar, aceptar como presente cualquier comando `openspec` global que devuelva una versión, incluido el npm global existente; así no se superponen dos gestores ni se cambia automáticamente una instalación existente. Homebrew resuelve Node como dependencia de la fórmula.

3. **Codex se enlaza por destinos concretos, sin sustituir `~/.codex`.** Versionar `home/.codex/AGENTS.md` y el árbol completo `home/.codex/skills/`; añadir enlaces Dotbot para `~/.codex/AGENTS.md` y `~/.codex/skills`. Mantener fuera del cambio el resto de configuración y estado local de Codex.

4. **La migración preserva árboles existentes.** Copiar al repositorio el contenido actual de `~/.codex/skills/` recorriendo también nombres ocultos, antes de enlazarlo. Para destinos existentes en el equipo de despliegue, reutilizar el flujo de confirmación y respaldo; ampliar el resolvedor para permitir mover un directorio solo después de que se confirme y respaldarlo íntegramente. Si se rechaza, no modificar el destino.

5. **Pruebas aisladas por catálogo y enlaces.** Usar stubs para `uname`, `rpm`, `sudo dnf`, `openspec` y `brew`; verificar instalaciones ausentes, estados ya presentes, arquitecturas soportadas/no soportadas, resolución de la versión global y conservación de contenido anidado/oculto en las pruebas de Dotbot.

## Risks / Trade-offs

- **La vista previa de ChatGPT Linux puede cambiar sus sistemas y releases compatibles** → Mantener URLs oficiales por arquitectura y omitir con explicación cualquier combinación que no figure como compatible; verificar el paquete instalado y sus metadatos.
- **Enlazar `.system/` hará que futuras actualizaciones del runtime puedan modificar el árbol versionado** → Incluir deliberadamente todo el contenido actual según la decisión del usuario y revisar los diffs después de actualizaciones de Codex.
- **Un directorio local de skills puede contener trabajo diferente al snapshot versionado** → Respaldarlo completo tras confirmación, sin borrarlo ni fusionarlo silenciosamente.
- **Dos instalaciones globales OpenSpec podrían competir por `PATH`** → Reconocer primero `openspec --version`; invocar Homebrew solo si no hay CLI global funcional.

## Migration Plan

1. Copiar fielmente `AGENTS.md` y todo `skills/` al repositorio, incluidos archivos ocultos, comprobar contenido y rutas relativas, y revisar que no se incluyan datos sensibles.
2. Añadir enlaces de Dotbot y la migración confirmada con respaldo recuperable para directorios Codex no gestionados.
3. Añadir OpenSpec al catálogo global y ChatGPT al catálogo Fedora con comprobaciones idempotentes; verificar con pruebas unitarias aisladas y simulación.
4. En rollback, desactivar los nuevos enlaces con el procedimiento de Dotbot y recuperar el respaldo; retirar ChatGPT/OpenSpec con el gestor correspondiente solo si la persona lo solicita.
