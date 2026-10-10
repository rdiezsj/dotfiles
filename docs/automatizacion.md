# Automatización

Los workflows de GitHub Actions tienen responsabilidades separadas: validar la
integridad técnica, detectar secretos y publicar la documentación. Ninguno
ejecuta el bootstrap ni modifica una estación Fedora. Todos fijan el runner
`ubuntu-26.04` para evitar las migraciones automáticas de `ubuntu-latest`.

## Validar repositorio

**Validar repositorio** se ejecuta al abrir o actualizar una propuesta contra
`main`, al integrar cambios en `main` y manualmente. Solo dispone de permisos
de lectura sobre el contenido del repositorio.

El workflow obtiene los submódulos e instala explícitamente `zsh`, `7z`, `jq`
y las utilidades de archivado y terminal que usan las pruebas, además de las
dependencias de documentación, `pre-commit` y Go. Antes de probar, la barrera
comprueba que esas herramientas están disponibles y ejecuta:

```bash
bash scripts/check.sh
```

Ese comando comprueba sintaxis Bash, pruebas unitarias y construcción estricta
de MkDocs. Para reproducirlo localmente, instala las herramientas que indica
su comprobación previa y las dependencias de documentación y `pre-commit` en
un entorno aislado antes de ejecutar el mismo comando. No sustituye las
validaciones en una estación Fedora destino ni ejecuta `./bootstrap` desde
este checkout de desarrollo.

Go se utiliza para instalar Gitleaks mediante `pre-commit`; su caché de módulos
está desactivada porque este repositorio no contiene un módulo Go ni `go.sum`.
Las acciones de preparación de Python y Go usan Node 24 y se fijan por SHA.

## Analizar secretos

**Analizar secretos** se ejecuta con los mismos disparadores: propuestas contra
`main`, cambios en `main` y ejecución manual. Usa Gitleaks sobre el historial
necesario para detectar secretos que se hubieran añadido y eliminado dentro de
la misma rama; no publica comentarios ni artefactos con hallazgos.

Para comprobarlo localmente:

```bash
pre-commit run --all-files
```

Consulta [Prevención de secretos](seguridad.md) para instalar el hook, actuar
ante una detección y registrar excepciones mínimas revisables.

## Publicar documentación

**Publicar documentación** se ejecuta manualmente o al incorporar en `main`
cambios en `docs/`, `README.md`, `mkdocs.yml`, `requirements-docs.txt` o su
propio workflow. Construye el sitio con `mkdocs build --strict` y lo despliega
en GitHub Pages. Es el único de los tres workflows con permisos de escritura
para Pages e identidad OIDC.

Para construir exactamente el contenido antes de publicarlo:

```bash
python3 -m venv /tmp/dotfiles-docs
/tmp/dotfiles-docs/bin/pip install -r requirements-docs.txt
/tmp/dotfiles-docs/bin/mkdocs build --strict
```

Una ejecución correcta construye y publica el sitio; no valida el bootstrap ni
reanuda otros workflows.

## Diagnóstico local: dotfiles doctor

Desde una terminal Zsh con los dotfiles desplegados:

```bash
dotfiles doctor
```

También puedes ejecutarlo directamente desde el checkout:

```bash
./bin/dotfiles doctor
```

El comando solo lee el estado local. Comprueba:

- Los enlaces declarados por Dotbot en `install.conf.yaml`, incluidos archivos
  y directorios: origen existente, destino gestionado y enlace correcto.
- La presencia de nombre y correo en la identidad Git **global**, sin mostrar
  sus valores. Si existe `~/.gitconfig.local`, comprueba que sea un archivo
  regular con permisos privados. Una identidad Git omitida voluntariamente se
  informa como incompleta; el bootstrap sigue permitiendo omitirla.
- La presencia de lockfiles no vacíos para los perfiles `base` y `resaltado` de
  Sheldon, en `${XDG_DATA_HOME:-$HOME/.local/share}/sheldon`. No valida sus
  revisiones ni el contenido de las cachés de plugins.
- Los valores aplicados de Ptyxis frente a `home/.config/ptyxis/config.dconf`,
  mediante `dconf read`. Una consulta fallida o que tarda más de cinco segundos
  se informa como no disponible.

Los enlaces se comprueban en las rutas de HOME declaradas por Dotbot. La
variable `DOTFILES_HOME` permite seleccionar otro checkout como referencia;
por defecto se usa el que contiene el comando. Para interpretar YAML necesita
el submódulo de PyYAML de Dotbot y Python 3; si faltan, no los instala y explica
qué no pudo comprobar.

| Código | Resultado |
| --- | --- |
| `0` | Todas las comprobaciones son conformes. |
| `1` | Hay deriva, aunque también haya comprobaciones no disponibles. |
| `2` | No hay deriva observada, pero el informe está incompleto; también se usa para argumentos no admitidos. |

Cada incidencia ofrece orientación manual. Revisa los destinos no gestionados
antes de volver a ejecutar `./bootstrap`: el doctor no confirma ni aplica
reparaciones. Una preferencia personal diferente se muestra como deriva para
que puedas decidir si conservarla o actualizar la declaración versionada.

No instala paquetes, usa `sudo`, accede a la red ni consulta Bitwarden o GNOME
Keyring. Tampoco escribe cachés de Python ni modifica preferencias. No es un
inventario exhaustivo de paquetes ni una validación de sesiones o secretos.

## Mantenimiento local: dotfiles update

`dotfiles update` es otro acceso al mismo mantenimiento que el alias `update`:

```bash
dotfiles update
# Desde el checkout:
./bin/dotfiles update
```

Ejecuta `scripts/actualizar.sh`, conserva su código de salida y respeta
`DOTFILES_HOME`. Sin esa variable, el script usa su propio checkout. El alias
`update` sigue disponible. Consulta el
[procedimiento de actualización](instalacion.md) para los gestores cubiertos,
los privilegios necesarios y la conservación de conflictos locales.

`dotfiles update --help` muestra el uso sin ejecutar el mantenimiento. Los
argumentos adicionales no admitidos devuelven `2` sin iniciar la actualización.
