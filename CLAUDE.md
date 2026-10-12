# Colossal Cave Adventure (Asciiverse packaging)

Open Adventure, Eric S. Raymond's forward-port of Crowther and Woods'
Adventure 2.5 (1995), packaged for the Asciiverse catalog (catalog id
`colossal-cave`, kind `adventure`) and as system packages. Not our code:
keep changes small, list every one in PATCHES.md.

- Remotes: `upstream` is gitlab.com/esr/open-adventure, `origin` is
  github.com/theasciiverse/colossal-cave.
- Branch `asciiverse` = an upstream release tag plus our commits.
- Release: tag `v<upstream version>-av.<n>` and push it.
- Local static build: `docker run --rm -v "$PWD":/src -w /src alpine:3.22
  sh asciiverse/build.sh` leaves `./advent`; Windows:
  `docker run --rm -v "$PWD":/src -w /src debian:bookworm sh
  asciiverse/build-windows.sh` leaves `./advent.exe`.
- av archive: `colossal-cave` (the start script, asciiverse/play) and
  `lib/advent`; saved games go to ~/.local/share/colossal-cave. On Windows
  the game itself moves into %APPDATA%\colossal-cave.
- Preview: `sh asciiverse/stage.sh linux` after a build, then
  `python3 asciiverse/record-preview.py`.
