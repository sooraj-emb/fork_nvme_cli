#!/bin/bash
# nvme-cli build script
# Usage: ./build-nvme-cli.sh [build|clean|rebuild]

set -e

BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$BASE/meson.build" ]]; then
    SRC="$BASE"
else
    SRC="$BASE/nvme_cli_git/fork_nvme_cli"
fi
BUILD="$SRC/.build"

build() {
    cd "$SRC"
    if [[ ! -d "$BUILD" ]]; then
        echo "Configuring meson..."
        meson setup "$BUILD"
    fi
    meson compile -C "$BUILD"
    echo "Build complete: $BUILD/nvme"
}

clean() {
    if [[ -d "$BUILD" ]]; then
        rm -rf "$BUILD"
        echo "Build directory removed."
    else
        echo "Nothing to clean."
    fi
}

[[ -d "$SRC" ]] || { echo "Error: source not found: $SRC"; exit 1; }
command -v meson &>/dev/null || { echo "Error: meson required"; exit 1; }

case "${1:-build}" in
    build)   build ;;
    clean)   clean ;;
    rebuild) clean && build ;;
    -h|--help)
        echo "Usage: $0 [build|clean|rebuild]"
        echo "  build   - configure and compile (default)"
        echo "  clean   - remove .build directory"
        echo "  rebuild - clean then build"
        ;;
    *)
        echo "Unknown option: $1"; exit 1
        ;;
esac
