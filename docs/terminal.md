# Terminal y Zsh

Zsh se enlaza desde el repositorio y puede establecerse como shell
predeterminada solo tras una confirmación independiente. Aceptar `exec zsh -l`
al final del bootstrap reemplaza únicamente la Bash desde la que se ejecutó.

## Entorno versionado

`~/.zshrc` declara `DOTFILES=~/.dotfiles` y añade, sin duplicados y solo si
existen, `~/.local/bin`, `~/.dotfiles/bin` y `~/.krew/bin`. Homebrew configura
sus rutas mediante `brew shellenv`.

Starship usa `~/.config/starship.toml`. Sheldon usa
`~/.config/sheldon/plugins.toml`, con revisiones SHA fijadas; sus clones y
lockfiles son estado local en `~/.local/share/sheldon/`. Zsh activa completado
de kubectl, modo Emacs y fzf con interfaz compacta.

Tras instalar, abre una sesión Zsh nueva y comprueba:

```bash
starship --version
sheldon --version
fzf --version
helm version --short
kubectl version --client
```

Para actualizar una revisión de plugin ya revisada, cambia exclusivamente su
SHA en el fichero versionado y materializa de forma explícita el estado local:

```bash
sheldon --non-interactive --profile base lock
sheldon --non-interactive --profile resaltado lock
exec zsh
```

No ejecutes `sheldon lock --update` durante el arranque de Zsh ni como parte de
una actualización rutinaria del bootstrap.

## Utilidades de archivos

`extract archivo.tar.gz` extrae tar, ZIP o 7z a un directorio homónimo sin
borrar el original. `compress carpeta` abre un asistente Gum para elegir
`tar.gz`, `tar.xz`, ZIP o 7z, nivel, destino y división opcional. Para
recomponer partes antes de extraerlas:

```bash
cat archivo.tar.xz.part-* > archivo.tar.xz
extract archivo.tar.xz
```
