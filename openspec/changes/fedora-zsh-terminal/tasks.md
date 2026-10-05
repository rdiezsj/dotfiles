# Tasks

## 1. Catálogo Homebrew para terminal

- [x] 1.1 Ampliar el catálogo Homebrew, que ya declara `firefoxpwa`, con `starship`, `zsh-completions`, `fzf`, `helm`, `kubernetes-cli`, `kubectx` y `tldr`; verificar sintaxis y ausencia de duplicados.
- [x] 1.2 Ampliar el ejecutor idempotente existente por fórmula para las herramientas de terminal, con resultados instalados, presentes y fallidos; verificar primera y segunda ejecución mediante un doble de `brew`.
- [x] 1.3 Actualizar la documentación del catálogo y del README con las fórmulas, su origen Homebrew y la verificación posterior; comprobar que los comandos documentados son válidos.

## 2. Configuración versionada y migración Dotbot

- [x] 2.1 Crear los archivos versionados `.zshrc`, `.zsh_aliases`, `.profile`, `.zprofile` y `home/config/starship.toml`, sin secretos ni contenido de historial; verificar `zsh -n` y la ausencia de valores sensibles.
- [x] 2.2 Declarar los enlaces Dotbot para los cuatro archivos de inicio y `home/config/starship.toml` en `~/.config/starship.toml`, con una migración que respalde destinos no gestionados con una marca fechada antes de sustituirlos; verificar destinos ausentes, ya gestionados y existentes no gestionados con directorios temporales.
- [x] 2.3 Ajustar el entorno Homebrew para que Bash conserve su bloque delimitado y Zsh lo cargue desde los archivos versionados; verificar que no se duplican bloques ni enlaces tras una segunda ejecución.

## 3. Integración Zsh y cambio de shell

- [x] 3.1 Integrar la instalación de fórmulas y la migración de archivos en el bootstrap, incluyendo simulación y resumen; verificar que un fallo de fórmula no detiene las restantes ni oculta el resultado.
- [x] 3.2 Implementar la confirmación explícita e idempotente de `chsh`, omitiéndola en simulación y cuando se rechaza; verificar aceptación, rechazo y Zsh ya predeterminada mediante dobles.
- [x] 3.3 Ejecutar la suite unitaria, `zsh -n` sobre la configuración, `git diff --check` y `openspec validate --strict`; documentar la validación manual de una nueva sesión Zsh en Fedora.
