#!/bin/bash
# Arduino IDE 2.x — macOS (.dmg)
set -e

ARDUINO_VERSION="${ARDUINO_VERSION:-latest}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/Applications}"
VOLUME_MOUNT=""

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

cleanup_dmg() {
    if [ -n "$VOLUME_MOUNT" ] && [ -d "$VOLUME_MOUNT" ]; then
        hdiutil detach "$VOLUME_MOUNT" -quiet 2>/dev/null || true
    fi
}
trap cleanup_dmg EXIT

uninstall_arduino() {
    log "Removendo Arduino IDE..."
    rm -rf "$HOME/Applications/Arduino IDE.app" 2>/dev/null || true
    rm -rf "/Applications/Arduino IDE.app" 2>/dev/null || true
    log "Concluído."
    exit 0
}

[ "${1:-}" = "--uninstall" ] && uninstall_arduino

command -v curl >/dev/null 2>&1 || { log "ERRO: curl necessário"; exit 1; }

ARCH=$(uname -m)
log "=== Instalador Arduino IDE (macOS) — arch $ARCH ==="

API_URL="https://api.github.com/repos/arduino/arduino-ide/releases/${ARDUINO_VERSION}"
JSON=$(curl -s "$API_URL")
DMG_URL=""

if [ "$ARCH" = "arm64" ]; then
    DMG_URL=$(echo "$JSON" | grep "browser_download_url" | cut -d'"' -f4 | grep -Ei '\.dmg' | grep -Ei 'arm64|aarch64|Apple|AppleSilicon' | head -1)
fi
if [ -z "$DMG_URL" ]; then
    DMG_URL=$(echo "$JSON" | grep "browser_download_url" | cut -d'"' -f4 | grep -Ei 'macos.*\.dmg|darwin.*\.dmg' | head -1)
fi
if [ -z "$DMG_URL" ]; then
    DMG_URL=$(echo "$JSON" | grep "browser_download_url" | cut -d'"' -f4 | grep -Ei '\.dmg' | grep -vi 'win32\|linux\|appimage' | head -1)
fi

if [ -z "$DMG_URL" ]; then
    log "ERRO: Não foi possível localizar um .dmg para macOS nesta release."
    exit 1
fi

log "Download: $DMG_URL"
mkdir -p "$INSTALL_DIR"
DMG_PATH="$INSTALL_DIR/.arduino-ide-tmp.dmg"
curl -L -f -o "$DMG_PATH" "$DMG_URL"

log "Montando imagem..."
VOLUME_MOUNT=$(hdiutil attach -nobrowse -quiet "$DMG_PATH" | awk 'END{print $NF}')
APP_SRC=$(find "$VOLUME_MOUNT" -maxdepth 2 -name "Arduino IDE.app" -print -quit)
if [ -z "$APP_SRC" ]; then
    APP_SRC=$(find "$VOLUME_MOUNT" -maxdepth 3 -name "*.app" -print -quit)
fi
if [ -z "$APP_SRC" ]; then
    log "ERRO: .app não encontrado no DMG"
    exit 1
fi

DEST_APP="$INSTALL_DIR/Arduino IDE.app"
log "Instalando em $DEST_APP..."
rm -rf "$DEST_APP"
ditto "$APP_SRC" "$DEST_APP"
xattr -dr com.apple.quarantine "$DEST_APP" 2>/dev/null || true

hdiutil detach "$VOLUME_MOUNT" -quiet 2>/dev/null || true
VOLUME_MOUNT=""
rm -f "$DMG_PATH"

log "=== Instalação concluída ==="
log "Abra: open -a \"$DEST_APP\""
log "Notas: permissões de serial/USB no macOS dependem do chip; pode ser necessário driver ou ajustes em Privacidade."
