#!/bin/sh
# Cross-builds Open Adventure for 64-bit Windows with MinGW-w64, run inside
# debian:bookworm:
#   docker run --rm -v "$PWD":/src -w /src debian:bookworm sh asciiverse/build-windows.sh
# Line editing comes from WinEditLine (BSD-3-Clause), an EditLine API for
# the Windows console, linked statically from MSYS2's mingw64 package
# (pinned by sha256 below). Leaves ./advent.exe.
set -eu
WEL=mingw-w64-x86_64-wineditline-2.208-1-any.pkg.tar.zst
WEL_SHA256=dfe7fab66632eececc73d84053eae2be8dd2146ecefe0fc2133277706084d7ea
apt-get update -qq >/dev/null
apt-get install -y -qq --no-install-recommends gcc-mingw-w64-x86-64 make \
  python3-yaml curl ca-certificates zstd >/dev/null
tmp=$(mktemp -d)
curl -fsSL "https://mirror.msys2.org/mingw/mingw64/$WEL" -o "$tmp/$WEL"
echo "$WEL_SHA256  $tmp/$WEL" | sha256sum -c -
tar --zstd -xf "$tmp/$WEL" -C "$tmp"
make clean >/dev/null 2>&1 || true
make CC=x86_64-w64-mingw32-gcc INC="-I$tmp/mingw64/include" \
  LIBS="$tmp/mingw64/lib/libedit.a" LDFLAGS=-static advent
mv advent advent.exe 2>/dev/null || true
x86_64-w64-mingw32-strip advent.exe
