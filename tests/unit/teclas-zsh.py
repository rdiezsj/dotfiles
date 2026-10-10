"""Comprueba la edición real de ZLE al recibir teclas por una pseudoterminal."""
import os
import pathlib
import pty
import select
import subprocess
import sys
import tempfile
import time

root = pathlib.Path(sys.argv[1])
cases = [
    ("Inicio CSI", b"abc\x1b[HX", "Xabc"),
    ("Inicio SS3", b"abc\x1bOHX", "Xabc"),
    ("Inicio numerico", b"abc\x1b[1~X", "Xabc"),
    ("Inicio rxvt", b"abc\x1b[7~X", "Xabc"),
    ("Fin CSI", b"abc\x01\x1b[FX", "abcX"),
    ("Fin SS3", b"abc\x01\x1bOFX", "abcX"),
    ("Fin numerico", b"abc\x01\x1b[4~X", "abcX"),
    ("Fin rxvt", b"abc\x01\x1b[8~X", "abcX"),
    ("Suprimir", b"abc\x01\x1b[3~", "bc"),
    ("Retroceso DEL", b"abc\x7f", "ab"),
    ("Retroceso BS", b"abc\x08", "ab"),
    ("Izquierda CSI", b"abc\x1b[DX", "abXc"),
    ("Izquierda SS3", b"abc\x1bODX", "abXc"),
    ("Derecha CSI", b"abc\x01\x1b[CX", "aXbc"),
    ("Derecha SS3", b"abc\x01\x1bOCX", "aXbc"),
    ("Ctrl izquierda", b"uno dos\x1b[1;5DX", "uno Xdos"),
    ("Ctrl derecha", b"uno dos\x01\x1b[1;5CX", "uno Xdos"),
    ("Ctrl Inicio", b"abc\x1b[1;5HX", "Xabc"),
    ("Ctrl Fin", b"abc\x01\x1b[1;5FX", "abcX"),
    ("Ctrl Suprimir", b"uno dos\x01\x1b[3;5~", " dos"),
    ("Alt Retroceso", b"uno dos\x1b\x7f", "uno "),
    ("Insertar", b"abc\x01\x1b[2~X\x1b[2~", "Xbc"),
]
for terminal in ("xterm-256color", "screen-256color", "dumb"):
    with tempfile.TemporaryDirectory(prefix="teclas-zsh-") as tmp:
        home = pathlib.Path(tmp)
        result = home / "resultado"
        (home / ".zshrc").write_text('''
brew() { print -r -- /nonexistent; }
sheldon() { return 0; }
starship() { return 0; }
kubectl() { return 0; }
secret-tool() { return 1; }
bw() { return 1; }
fzf() { print -r -- 'zle -N fzf-history-widget; bindkey "^R" fzf-history-widget'; }
fzf-history-widget() { :; }
source "$DOTFILES/home/.zshrc"
[[ $(bindkey '^R') == *fzf-history-widget* ]] || exit 9
[[ $(bindkey '^A') == *beginning-of-line* ]] || exit 9
[[ $(bindkey $'\\e[Z') == *reverse-menu-complete* ]] || exit 9
PROMPT='LISTO> '
capturar() { print -r -- "$BUFFER" >> "$RESULTADO"; BUFFER=''; zle reset-prompt; }
zle -N capturar
bindkey '^X^T' capturar
''')
        env = {**os.environ, "HOME": tmp, "ZDOTDIR": tmp, "TERM": terminal,
               "DOTFILES": str(root), "DOTFILES_SKIP_BREW_SHELLENV": "true",
               "XDG_CONFIG_HOME": tmp + "/config", "XDG_DATA_HOME": tmp + "/data",
               "XDG_STATE_HOME": tmp + "/state", "RESULTADO": str(result)}
        env.pop("BW_SESSION", None)
        master, slave = pty.openpty()
        process = subprocess.Popen(["zsh", "-di"], env=env, stdin=slave,
                                   stdout=slave, stderr=slave)
        os.close(slave)
        try:
            output = b""
            deadline = time.monotonic() + 10
            while b"LISTO> " not in output:
                if time.monotonic() > deadline:
                    raise AssertionError(f"Zsh no arranca: {terminal}: {output!r}")
                if select.select([master], [], [], 0.1)[0]:
                    output += os.read(master, 65536)
            for number, (name, keys, expected) in enumerate(cases, 1):
                os.write(master, keys + b"\x18\x14")
                deadline = time.monotonic() + 3
                while True:
                    lines = result.read_text().splitlines() if result.exists() else []
                    if len(lines) >= number:
                        assert lines[-1] == expected, (terminal, name, lines[-1], expected)
                        break
                    if time.monotonic() > deadline:
                        raise AssertionError(f"Sin resultado: {terminal}: {name}")
                    if select.select([master], [], [], 0.01)[0]:
                        os.read(master, 65536)
            print(f"PASS {terminal}: {len(cases)} secuencias y Ctrl+R de fzf")
        finally:
            process.kill()
            process.wait(timeout=5)
            os.close(master)
