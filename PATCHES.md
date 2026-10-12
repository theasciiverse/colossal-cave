# Changes from upstream

This is the Asciiverse packaging of Colossal Cave Adventure in
[Open Adventure](https://gitlab.com/esr/open-adventure), Eric S. Raymond's
forward-port of Adventure 2.5, the 1995 version by Will Crowther and Don
Woods and the last one by its original authors. Built from upstream's 1.22
tag (commit e616052, 2026-07-08). Upstream is the `upstream` remote; the
`asciiverse` branch carries the changes below.

Licence: BSD-2-Clause (COPYING). The sources carry
"SPDX-FileCopyrightText: (C) 1977, 2005 by Will Crowther and Don Woods";
upstream's README says "The authors have given permission and
encouragement for this release".

## Code

- `main.c`, Windows only (`#ifdef _WIN32`): at start, the game moves into
  `%APPDATA%\colossal-cave` (creating it), so a game saved with SAVE (the
  game asks for a file name and writes it to the current folder) is kept
  out of the install folder, which av replaces on updates. Skipped when
  script files are given on the command line. Linux and macOS builds are
  unchanged; there the start script does the same (below).

## Packaging (new files)

- `asciiverse/build.sh`: a fully static Linux build in Alpine 3.22 (libedit
  and ncurses linked in), and macOS builds that link only the system's own
  libedit (the script fails otherwise).
- `asciiverse/build-windows.sh`: a MinGW-w64 cross-build for 64-bit
  Windows in Debian, with WinEditLine 2.208 (BSD-3-Clause, MSYS2's
  package, pinned by sha256) linked statically for line editing.
- `asciiverse/play`: the start script, named `colossal-cave` in the av
  archive. It runs the game from `~/.local/share/colossal-cave` (or
  `$XDG_DATA_HOME/colossal-cave`), so saved games land there.
- `asciiverse/stage.sh`: lays out each av archive.
- `asciiverse/licenses/`: the licences of the libraries linked into the
  static builds: libedit (BSD-3-Clause, from libedit-20250104-3.1),
  ncurses (MIT-style, from 6.5-20250503, the versions in Alpine 3.22) and
  WinEditLine (BSD-3-Clause).
- `asciiverse/nfpm.yaml`: .deb, .rpm, .apk and Arch packages named
  `colossal-cave-asciiverse`, installing `advent` and a `colossal-cave`
  link to it in /usr/bin (they conflict with a distribution's
  open-adventure).
- `asciiverse/colossal-cave.cast` and `asciiverse/record-preview.py`: the
  catalog preview and the script that records it.
- `.github/workflows/release.yml`: builds all of it on a tag.
- `.gitignore`: build output of the above.

## Not built or not shipped

- Upstream's `advent.desktop`: Asciiverse packages add no menu entries.
- The man page (`advent.6`, made from `advent.adoc` by asciidoctor); the
  system packages carry `advent.adoc` itself instead.
- `cheat`, upstream's save-file editor for its test suite.
