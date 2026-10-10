#!/usr/bin/env python3

"""Prueba el diagnóstico en una estación temporal sin datos del usuario."""

import configparser
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

RAIZ = Path(__file__).resolve().parents[2]
PRIVADO = "identidad-sintetica-no-publicar"


def guardar(path, contenido, modo=0o644):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(contenido)
    path.chmod(modo)


def estado(path):
    # No se comparan tiempos de acceso: una lectura puede actualizarlos.
    resultado = {}
    for p in sorted(path.rglob("*")):
        st = p.lstat()
        contenido = os.readlink(p) if p.is_symlink() else p.read_bytes() if p.is_file() else None
        resultado[str(p.relative_to(path))] = (st.st_mode, st.st_mtime_ns, contenido)
    return resultado


with tempfile.TemporaryDirectory(prefix="dotfiles-doctor-") as temporal:
    base = Path(temporal)
    home = base / "home"
    checkout = base / "checkout con espacios"
    stubs = base / "bin"
    for p in (home, checkout, stubs):
        p.mkdir()
    guardar(checkout / "home/archivo", "versionado\n")
    guardar(checkout / "home/directorio con espacios/config", "contenido\n")
    guardar(checkout / "install.conf.yaml", "- link:\n    ~/.archivo: home/archivo\n    ~/.directorio: home/directorio con espacios\n")
    yaml_dir = checkout / "dotbot/lib/pyyaml/lib"
    yaml_dir.parent.mkdir(parents=True)
    shutil.copytree(RAIZ / "dotbot/lib/pyyaml/lib", yaml_dir,
                    ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    home.joinpath(".archivo").symlink_to(os.path.relpath(checkout / "home/archivo", home))
    home.joinpath(".directorio").symlink_to(checkout / "home/directorio con espacios", target_is_directory=True)
    guardar(home / ".gitconfig", '[include]\n path = ~/.gitconfig.local\n')
    guardar(home / ".gitconfig.local", f'[user]\n name = {PRIVADO}\n email = {PRIVADO}@example.invalid\n', 0o600)
    datos = base / "datos xdg/sheldon"
    for perfil in ("base", "resaltado"):
        guardar(datos / f"plugins.{perfil}.lock", "estado local\n")
    config = checkout / "home/.config/ptyxis/config.dconf"
    guardar(config, (RAIZ / "home/.config/ptyxis/config.dconf").read_text())
    parser = configparser.ConfigParser(interpolation=None)
    parser.optionxform = str
    parser.read(config)
    preferencias = {
        "/org/gnome/Ptyxis/" + ("" if seccion == "/" else seccion.strip("/") + "/") + clave: valor
        for seccion in parser.sections() for clave, valor in parser.items(seccion)
    }
    import json
    guardar(base / "preferencias.json", json.dumps(preferencias))
    guardar(stubs / "dconf", '''#!/usr/bin/env python3
import json, os, sys
assert sys.argv[1] == "read", "Solo se permiten lecturas"
if os.environ.get("DCONF_TIMEOUT"):
    import time
    time.sleep(10)
if os.environ.get("DCONF_FALLA"):
    print("identidad-sintetica-no-publicar", file=sys.stderr)
    sys.exit(1)
print(json.load(open(os.environ["PREFERENCIAS"])) .get(sys.argv[2], ""))
''', 0o755)
    guardar(stubs / "git", '#!/bin/sh\n[ "$#" = 5 ] && [ "$1" = config ] && [ "$2" = --global ] && [ "$3" = --includes ] && [ "$4" = --get ] || exit 99\nexec /usr/bin/git "$@"\n', 0o755)
    for comando in ("bw", "secret-tool", "sudo", "curl", "brew", "sheldon", "gsettings"):
        guardar(stubs / comando, '#!/bin/sh\necho llamada-prohibida >> "$VIGILANCIA"\nexit 99\n', 0o755)
    env = {
        "HOME": str(home), "PATH": f"{stubs}:/usr/bin:/bin",
        "DOTFILES_HOME": str(checkout), "XDG_DATA_HOME": str(datos.parent),
        "XDG_CONFIG_HOME": str(base / "config xdg distinta"),
        "GIT_CONFIG_NOSYSTEM": "1", "GIT_CONFIG_GLOBAL": str(home / ".gitconfig"),
        "PYTHONDONTWRITEBYTECODE": "1", "LC_ALL": "C.UTF-8",
        "PREFERENCIAS": str(base / "preferencias.json"),
        "VIGILANCIA": str(base / "llamadas-prohibidas"), "BW_SESSION": PRIVADO,
    }

    def ejecutar(codigo, texto, args=("doctor",), extra=None):
        resultado = subprocess.run(["bash", str(RAIZ / "bin/dotfiles"), *args], env=env | (extra or {}),
                                   capture_output=True, text=True, timeout=30)
        salida = resultado.stdout + resultado.stderr
        assert resultado.returncode == codigo, (codigo, resultado.returncode, salida)
        assert texto in salida, (texto, salida)
        assert PRIVADO not in salida, salida
        assert not (base / "llamadas-prohibidas").exists(), "Se ejecutó una operación prohibida"
        return salida

    antes = estado(base)
    informe = ejecutar(0, "Resumen:")
    assert informe == ejecutar(0, "Resumen:")
    assert antes == estado(base), "El diagnóstico modificó la estación o el checkout"
    assert not list(yaml_dir.rglob("__pycache__")), "Se escribió caché de Python"
    ejecutar(2, "Uso:", ("desconocido",))
    ejecutar(2, "Uso:", ("doctor", "--reparar"))
    ejecutar(0, "Uso:", ("--help",))
    assert antes == estado(base), "Los argumentos no admitidos modificaron el estado"

    archivo = home / ".archivo"
    archivo.unlink()
    ejecutar(1, "destino ausente")
    guardar(archivo, "configuracion personal conservada\n")
    ejecutar(1, "destino no gestionado")
    assert archivo.read_text() == "configuracion personal conservada\n"
    archivo.unlink()
    archivo.symlink_to(checkout / "home/directorio con espacios")
    ejecutar(1, "enlace a otro origen")
    archivo.unlink()
    archivo.symlink_to(checkout / "inexistente")
    ejecutar(1, "enlace roto")
    archivo.unlink()
    archivo.symlink_to(checkout / "home/archivo")
    origen = checkout / "home/archivo"
    origen.unlink()
    ejecutar(1, "origen ausente")
    guardar(origen, "versionado\n")

    identidad = home / ".gitconfig.local"
    identidad.chmod(0o644)
    ejecutar(1, "permisos")
    identidad.chmod(0o600)
    guardar(identidad, f'[user]\n name = {PRIVADO}\n', 0o600)
    ejecutar(1, "identidad global incompleta")
    guardar(identidad, f'[user]\n name = {PRIVADO}\n email = {PRIVADO}@example.invalid\n', 0o600)
    # El archivo local es opcional si existe identidad global completa.
    identidad.unlink()
    guardar(home / ".gitconfig", f'[user]\n name = {PRIVADO}\n email = {PRIVADO}@example.invalid\n')
    ejecutar(0, "identidad global configurada")

    lock = datos / "plugins.resaltado.lock"
    lock.unlink()
    ejecutar(1, "perfil resaltado pendiente")
    guardar(lock, "")
    ejecutar(1, "perfil resaltado pendiente")
    guardar(lock, "estado local\n")
    preferencias["/org/gnome/Ptyxis/interface-style"] = "'light'"
    guardar(base / "preferencias.json", json.dumps(preferencias))
    ejecutar(1, "interface-style")
    preferencias["/org/gnome/Ptyxis/interface-style"] = "'dark'"
    guardar(base / "preferencias.json", json.dumps(preferencias))
    ejecutar(2, "no se pudo consultar", extra={"DCONF_FALLA": "1"})
    ejecutar(2, "no se pudo consultar", extra={"DCONF_TIMEOUT": "1"})
    dconf = stubs / "dconf"
    dconf.rename(stubs / "dconf-pendiente")
    # Oculta también cualquier dconf real del anfitrión mediante un stub fallido.
    guardar(dconf, "#!/bin/sh\nexit 127\n", 0o755)
    ejecutar(2, "no se pudo consultar")
    dconf.unlink()
    (stubs / "dconf-pendiente").rename(dconf)
    lock.unlink()
    ejecutar(1, "no comprobado", extra={"DCONF_FALLA": "1"})
    guardar(lock, "estado local\n")
    declaracion = checkout / "install.conf.yaml"
    original = declaracion.read_text()
    guardar(declaracion, "- link: [invalido\n")
    ejecutar(2, "declaración")
    guardar(declaracion, "- link: [formato, no, admitido]\n")
    ejecutar(2, "declaración")
    guardar(declaracion, original)
    config.unlink()
    ejecutar(2, "configuración declarada")
    guardar(config, (RAIZ / "home/.config/ptyxis/config.dconf").read_text())
    guardar(stubs / "git", '#!/bin/sh\necho identidad-sintetica-no-publicar >&2\nexit 128\n', 0o755)
    ejecutar(2, "no se pudo consultar la identidad")
    (stubs / "git").unlink()
    shutil.rmtree(checkout / "dotbot")
    ejecutar(2, "lector YAML")
    print("PASS doctor: enlaces, identidad, XDG, Ptyxis, estados y privacidad; ejecución repetida sin escrituras")
