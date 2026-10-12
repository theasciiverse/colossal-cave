#!/bin/sh
# Lays out the av archive for one platform in stage/, after a build:
#   sh asciiverse/stage.sh linux|macos|windows
# Linux and macOS: colossal-cave (the start script, asciiverse/play) at the
# top, where av looks for it, and the game in lib/advent. Windows: the game
# itself as colossal-cave.exe (it moves into %APPDATA%\colossal-cave on its
# own, see PATCHES.md). Each carries the licences of what is linked in.
set -eu
rm -rf stage
mkdir -p stage/licenses
cp COPYING README.adoc PATCHES.md stage/
case "$1" in
  linux)
    mkdir -p stage/lib
    cp advent stage/lib/advent
    cp asciiverse/play stage/colossal-cave
    cp asciiverse/licenses/libedit.txt asciiverse/licenses/ncurses.txt stage/licenses/ ;;
  macos)
    # libedit and ncurses come from macOS itself, so nothing is linked in
    mkdir -p stage/lib
    cp advent stage/lib/advent
    cp asciiverse/play stage/colossal-cave
    rmdir stage/licenses ;;
  windows)
    cp advent.exe stage/colossal-cave.exe
    cp asciiverse/licenses/wineditline.txt stage/licenses/ ;;
  *) echo "usage: stage.sh linux|macos|windows" >&2; exit 2 ;;
esac
chmod 755 stage/colossal-cave* stage/lib/advent 2>/dev/null || true
