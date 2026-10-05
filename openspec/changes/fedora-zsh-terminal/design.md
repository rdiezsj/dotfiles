# Design

## Context

Zsh, Homebrew y su bloque de entorno ya forman parte del bootstrap. El catálogo Homebrew está vacío y no existe aún una configuración Zsh versionada. Véanse `proposal.md` y las especificaciones delta para el comportamiento esperado.

## Goals / Non-Goals

**Goals:**

- Incorporar un catálogo Homebrew de herramientas de terminal que pueda reconciliarse sin reinstalaciones.
- Mantener la configuración Zsh y Starship en el repositorio, enlazada de forma conservadora mediante Dotbot.
- Hacer opcional y claramente visible el cambio de shell predeterminada.

**Non-Goals:**

- Instalar frameworks de Zsh, temas adicionales o plugins de terceros no declarados.
- Versionar historial, tokens, credenciales, cachés, configuraciones de Kubernetes o preferencias específicas del equipo.
- Configurar Terminator, GNOME, input-remapper u otras aplicaciones gráficas.

## Decisions

### Fórmulas Homebrew declarativas

El catálogo enumerará `starship`, `zsh-completions`, `fzf`, `helm`, `kubernetes-cli`, `kubectx` y `tldr`. El ejecutor comprobará cada fórmula antes de instalarla y continuará con las restantes si una falla, dejando el detalle en el resumen.

Alternativa descartada: instalar un único lote sin estado por fórmula. Impediría una reejecución informativa y aislar fallos.

### Archivos de inicio completos y versionados

`home/.zshrc` será la configuración interactiva final y cargará Homebrew, historial, `.zsh_aliases`, `compinit`, fzf y Starship. `home/.zprofile` contendrá el entorno de inicio de sesión de Zsh y `home/.profile` el entorno POSIX equivalente. `home/config/starship.toml` será la fuente versionada de Starship y Dotbot lo enlazará en `~/.config/starship.toml`. Se evitarán Oh My Zsh y gestores de plugins para mantener el arranque ligero y la procedencia de cada ajuste visible.

Alternativa descartada: incorporar un framework completo de plugins. Añadiría dependencias dinámicas y configuración implícita antes de tener necesidades concretas.

### Migración controlada de destinos existentes

Dotbot declarará los enlaces de `.zshrc`, `.zsh_aliases`, `.profile`, `.zprofile` y `home/config/starship.toml` en `~/.config/starship.toml`. Antes de sustituir un destino existente no gestionado, el bootstrap creará un respaldo fechado y recuperable, mostrará su ruta y solo continuará tras la confirmación global ya existente. Esto incluye el `.zshrc` provisional creado por la fase previa de Homebrew.

Alternativa descartada: escribir o concatenar directamente en `.zshrc`. Dificultaría distinguir contenido gestionado de contenido personal y dejaría la configuración final repartida.

### `chsh` siempre optativo

El bootstrap solo ofrecerá `chsh -s <ruta-zsh>` después de comprobar que Zsh existe y de obtener confirmación explícita. Una negativa o el modo de simulación no realizará el cambio.

Alternativa descartada: cambiar automáticamente la shell al instalar Zsh. Es una modificación de cuenta persistente que requiere consentimiento individual.

## Risks / Trade-offs

- [`.zshrc` creado anteriormente por el bloque Homebrew] → crear respaldo fechado, mostrarlo y sustituirlo únicamente dentro de la migración confirmada.
- [Fórmula Homebrew no disponible] → continuar con las demás y registrar el fallo por fórmula.
- [Inicialización dependiente de fórmula ausente] → condicionar cada bloque al binario existente para que Zsh continúe arrancando.
- [Cambio de shell no visible de inmediato] → informar de que requiere abrir una nueva sesión.

## Migration Plan

1. Ejecutar simulación y revisar fórmulas, destinos Dotbot y respaldos que se crearían.
2. Ejecutar el bootstrap, revisar los respaldos creados y confirmar o rechazar `chsh`.
3. Abrir una sesión Zsh nueva y verificar `starship`, completado, fzf y las CLI instaladas.
4. Reejecutar el bootstrap y comprobar que fórmulas y enlaces se declaran presentes.
