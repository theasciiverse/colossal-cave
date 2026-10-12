#!/usr/bin/env python3
"""Records asciiverse/colossal-cave.cast, the catalog preview, at 100x30
(hub/RECORDING.md): the opening, the building, lamp and keys, and down
through the grate into the cave, typed at a human pace, through the same
start script av runs (stage/colossal-cave, made by `sh asciiverse/stage.sh
linux` after a build), from the install folder as av does, with a
throwaway HOME. Usage: python3 asciiverse/record-preview.py"""
import os, pty, shutil, struct, fcntl, select, tempfile, termios, time

MOVES = ["no", "in", "take lamp", "take keys", "out", "south", "south", "south",
         "unlock grate", "down", "west", "light lamp", "west", "take rod"]
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
stage = f"{root}/stage"
home = tempfile.mkdtemp()
env = dict(os.environ, HOME=home, TERM="xterm-256color", COLORTERM="truecolor", LANG="C.UTF-8")
env.pop("XDG_DATA_HOME", None)

pid, fd = pty.fork()
if pid == 0:
    os.chdir(stage)
    os.execvpe("asciinema", ["asciinema", "rec", "--overwrite", "-q", "-i", "2",
        "--capture-env", "TERM,COLORTERM,LANG", "-c", "./colossal-cave",
        f"{root}/asciiverse/colossal-cave.cast"], env)
fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 30, 100, 0, 0))

def pump(t):
    end = time.time() + t
    while time.time() < end:
        r, _, _ = select.select([fd], [], [], 0.03)
        if r:
            try: os.read(fd, 65536)
            except OSError: return

def type_line(text, wait):
    for c in text:
        os.write(fd, c.encode()); pump(0.09)
    os.write(fd, b"\r"); pump(wait)

pump(2.5)
for move in MOVES:
    type_line(move, 2.4)
type_line("quit", 1.2)
type_line("y", 3.0)
for _ in range(50):
    if os.waitpid(pid, os.WNOHANG)[0]: break
    time.sleep(0.2)
shutil.rmtree(home, ignore_errors=True)
