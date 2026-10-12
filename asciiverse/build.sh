#!/bin/sh
# Builds Open Adventure (advent) for the Asciiverse catalog.
# Linux: run inside alpine:3.22 for a fully static binary with libedit and
# ncurses linked in:
#   docker run --rm -v "$PWD":/src -w /src alpine:3.22 sh asciiverse/build.sh
# macOS: run on the runner with CC_ARCH set to x86_64 or arm64; it links the
# system's own libedit (macOS ships it) and nothing else (checked below).
# Leaves ./advent.
set -eu
if [ -f /etc/alpine-release ]; then
  apk add --no-cache build-base pkgconf python3 py3-yaml \
    libedit-dev libedit-static ncurses-dev ncurses-static >/dev/null
  make clean >/dev/null 2>&1 || true
  make LDFLAGS=-static LIBS="$(pkg-config --static --libs libedit)" advent
else
  # make_dungeon.py needs PyYAML; keep it out of the system Python
  python3 -m venv .venv-build
  .venv-build/bin/pip install --quiet pyyaml
  PATH="$PWD/.venv-build/bin:$PATH"
  make clean >/dev/null 2>&1 || true
  # LIBS and INC set here so a Homebrew libedit found by pkg-config is
  # never used; the SDK has <editline/readline.h> for /usr/lib/libedit
  make CC="cc -arch $CC_ARCH" LIBS=-ledit INC= advent
  otool -L advent
  if otool -L advent | tail -n +2 | grep -v -E "^\s*/(usr/lib|System/Library)/"; then
    echo "advent links a library outside the system" >&2; exit 1
  fi
fi
strip advent
