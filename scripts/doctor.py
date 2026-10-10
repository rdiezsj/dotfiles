#!/usr/bin/env python3

"""Diagnóstico local de configuración; no aplica cambios ni consulta secretos."""

import configparser
import os
from pathlib import Path
import stat
import subprocess
import sys

# También evita cachés si se invoca directamente con Python.
sys.dont_write_bytecode = True


class Informe:
    def __init__(self):
        self.contadores = {"conforme": 0, "deriva": 0, "no comprobado": 0}

    def registrar(self, estado, mensaje):
        self.contadores[estado] += 1
        print(f"[{estado}] {mensaje}")

    def terminar(self):
        print("Resumen: " + ", ".join(f"{numero} {estado}" for estado, numero in self.contadores.items()))
        if self.contadores["deriva"]:
            return 1
        return 2 if self.contadores["no comprobado"] else 0


def consultar(argumentos):
    """Oculta errores externos y acota consultas sin interacción."""
    try:
        resultado = subprocess.run(argumentos, stdin=subprocess.DEVNULL, stdout=subprocess.PIPE,
                                   stderr=subprocess.DEVNULL, text=True, timeout=5)
        return resultado.returncode, resultado.stdout.strip()
    except (OSError, subprocess.TimeoutExpired, UnicodeError):
        return None, ""


def comprobar_enlaces(raiz, home, informe):
    lector = raiz / "dotbot/lib/pyyaml/lib"
    if not (lector / "yaml/__init__.py").is_file():
        informe.registrar("no comprobado", "Dotbot: falta el lector YAML; inicializa sus submódulos para comprobar enlaces.")
        return
    sys.path.insert(0, str(lector))
    try:
        import yaml
    except ImportError:
        informe.registrar("no comprobado", "Dotbot: no se pudo cargar el lector YAML; revisa sus submódulos.")
        return
    try:
        with (raiz / "install.conf.yaml").open() as archivo:
            declaracion = yaml.safe_load(archivo)
        if not isinstance(declaracion, list):
            raise ValueError
        enlaces = []
        for paso in declaracion:
            if not isinstance(paso, dict):
                raise ValueError
            if "link" not in paso:
                continue
            if not isinstance(paso["link"], dict):
                raise ValueError
            for destino, origen in paso["link"].items():
                if isinstance(origen, dict):
                    origen = origen.get("path")
                if not isinstance(destino, str) or not destino.startswith("~/") or not isinstance(origen, str):
                    raise ValueError
                enlaces.append((home / destino[2:], raiz / origen))
        if not enlaces:
            raise ValueError
    except (OSError, UnicodeError, ValueError, yaml.YAMLError):
        informe.registrar("no comprobado", "Dotbot: no se pudo leer la declaración de enlaces; revisa install.conf.yaml.")
        return

    for destino, origen in enlaces:
        try:
            if not origen.exists():
                detalle = "origen ausente"
            elif not destino.is_symlink():
                detalle = "destino no gestionado" if destino.exists() else "destino ausente"
            elif not destino.exists():
                detalle = "enlace roto"
            elif destino.resolve() != origen.resolve():
                detalle = "enlace a otro origen"
            else:
                informe.registrar("conforme", f"Dotbot: {destino}")
                continue
            informe.registrar("deriva", f"Dotbot: {destino}: {detalle}; revisa el destino y reejecuta el bootstrap.")
        except (OSError, RuntimeError):
            informe.registrar("no comprobado", f"Dotbot: no se pudo inspeccionar {destino}; revisa sus permisos.")


def comprobar_identidad(home, informe):
    resultados = [consultar(["git", "config", "--global", "--includes", "--get", clave])
                  for clave in ("user.name", "user.email")]
    if any(codigo not in (0, 1) for codigo, _ in resultados):
        informe.registrar("no comprobado", "Git: no se pudo consultar la identidad global; revisa Git y su configuración.")
    elif all(codigo == 0 and valor for codigo, valor in resultados):
        informe.registrar("conforme", "Git: identidad global configurada (valores ocultos).")
    else:
        informe.registrar("deriva", "Git: identidad global incompleta; configúrala mediante el bootstrap si la necesitas.")

    archivo = home / ".gitconfig.local"
    try:
        if not archivo.exists() and not archivo.is_symlink():
            return  # El bootstrap conserva una identidad global existente.
        modo = archivo.lstat().st_mode
        if not stat.S_ISREG(modo) or modo & 0o077:
            informe.registrar("deriva", "Git: ~/.gitconfig.local debe ser un archivo regular con permisos privados; revisa el archivo y usa chmod 600 si corresponde.")
        else:
            informe.registrar("conforme", "Git: permisos privados de ~/.gitconfig.local.")
    except OSError:
        informe.registrar("no comprobado", "Git: no se pudieron comprobar los permisos de ~/.gitconfig.local.")


def comprobar_sheldon(home, informe):
    datos = Path(os.environ.get("XDG_DATA_HOME") or home / ".local/share") / "sheldon"
    for perfil in ("base", "resaltado"):
        archivo = datos / f"plugins.{perfil}.lock"
        try:
            if archivo.is_file() and archivo.stat().st_size > 0:
                informe.registrar("conforme", f"Sheldon: perfil {perfil} materializado (presencia del lockfile).")
            else:
                informe.registrar("deriva", f"Sheldon: perfil {perfil} pendiente; reejecuta el bootstrap para materializarlo.")
        except OSError:
            informe.registrar("no comprobado", f"Sheldon: no se pudo comprobar el perfil {perfil}; revisa sus permisos.")


def comprobar_ptyxis(raiz, informe):
    configuracion = configparser.ConfigParser(interpolation=None)
    configuracion.optionxform = str
    try:
        with (raiz / "home/.config/ptyxis/config.dconf").open() as archivo:
            configuracion.read_file(archivo)
        if not configuracion.sections() or any(not list(configuracion.items(s)) for s in configuracion.sections()):
            raise ValueError
    except (OSError, UnicodeError, ValueError, configparser.Error):
        informe.registrar("no comprobado", "Ptyxis: no se pudo leer la configuración declarada; revisa el checkout.")
        return
    for seccion in configuracion.sections():
        prefijo = "/org/gnome/Ptyxis/" + ("" if seccion == "/" else seccion.strip("/") + "/")
        for clave, esperado in configuracion.items(seccion):
            codigo, actual = consultar(["dconf", "read", prefijo + clave])
            if codigo != 0:
                informe.registrar("no comprobado", "Ptyxis: no se pudo consultar dconf; comprueba su instalación y la sesión GNOME.")
                return
            if actual != esperado.strip():
                informe.registrar("deriva", f"Ptyxis: {seccion}/{clave} difiere de lo declarado; revisa tus preferencias o reejecuta el bootstrap.")
            else:
                informe.registrar("conforme", f"Ptyxis: {seccion}/{clave}.")


def main():
    raiz = Path(os.environ.get("DOTFILES_HOME") or Path(__file__).resolve().parents[1])
    home = Path.home()
    informe = Informe()
    print("Dotfiles doctor: diagnóstico local de solo lectura")
    comprobar_enlaces(raiz, home, informe)
    comprobar_identidad(home, informe)
    comprobar_sheldon(home, informe)
    comprobar_ptyxis(raiz, informe)
    return informe.terminar()


if __name__ == "__main__":
    sys.exit(main())
