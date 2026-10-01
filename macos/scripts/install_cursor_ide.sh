#!/bin/bash
# Cursor — macOS: baixa o pacote estável e copia para /Applications.
# Atualizações futuras ficam a cargo do próprio app no macOS.
set -e
set -o pipefail

CURSOR_APP="/Applications/Cursor.app"
SYSTEM_BIN_LINK="/usr/local/bin/cursor"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

detect_platform() {
    case "$(uname -m)" in
        arm64) echo "darwin-arm64" ;;
        x86_64) echo "darwin-x64" ;;
        *)
            echo "ERRO: Arquitetura não suportada: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

CURSOR_PLATFORM="$(detect_platform)"
CURSOR_API_URL="https://www.cursor.com/api/download?platform=${CURSOR_PLATFORM}&releaseTrack=stable"

ensure_curl() {
    command -v curl >/dev/null 2>&1 || { log "ERRO: curl não encontrado"; exit 1; }
}

ensure_jq() {
    if command -v jq >/dev/null 2>&1; then
        return 0
    fi
    if [ -x "$SCRIPT_DIR/install_jq.sh" ]; then
        log "Instalando jq (necessário para ler a URL da API)..."
        "$SCRIPT_DIR/install_jq.sh"
    fi
    command -v jq >/dev/null 2>&1 || { log "ERRO: jq não disponível após install_jq.sh"; exit 1; }
}

get_download_url() {
    log "Obtendo URL de download (plataforma: $CURSOR_PLATFORM)..."
    local API_RESPONSE
    API_RESPONSE=$(curl -sL --connect-timeout 30 --max-time 120 "$CURSOR_API_URL") || true
    if [ -z "$API_RESPONSE" ]; then
        log "ERRO: falha ao consultar a API do Cursor"
        exit 1
    fi
    local DOWNLOAD_URL
    DOWNLOAD_URL=$(echo "$API_RESPONSE" | jq -r '.downloadUrl // empty')
    if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" = "null" ]; then
        log "ERRO: resposta da API sem downloadUrl"
        exit 1
    fi
    echo "$DOWNLOAD_URL"
}

find_cursor_cli() {
    local base="$CURSOR_APP/Contents/Resources/app"
    if [ -x "$base/bin/cursor" ]; then
        echo "$base/bin/cursor"
        return 0
    fi
    if [ -x "$base/bin/cursor.sh" ]; then
        echo "$base/bin/cursor.sh"
        return 0
    fi
    echo ""
}

install_app_from_archive() {
    local download_url="$1"
    local tmp archive ext found
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT

    ext="${download_url##*.}"
    ext="${ext%%\?*}"
    case "$ext" in
        zip|ZIP) archive="$tmp/cursor.$ext" ;;
        dmg|DMG) archive="$tmp/cursor.$ext" ;;
        *) archive="$tmp/cursor.bin" ;;
    esac

    log "Baixando pacote..."
    curl -L --fail --progress-bar -o "$archive" "$download_url"

    found=""
    case "$ext" in
        zip|ZIP)
            log "Extraindo ZIP..."
            mkdir -p "$tmp/extract"
            unzip -q -o "$archive" -d "$tmp/extract"
            found=$(find "$tmp/extract" -name "Cursor.app" -maxdepth 6 -print -quit)
            ;;
        dmg|DMG)
            log "Montando DMG..."
            local vol
            vol=$(hdiutil attach -nobrowse -quiet "$archive" | awk 'END{print $NF}')
            found=$(find "$vol" -name "Cursor.app" -maxdepth 4 -print -quit)
            if [ -z "$found" ]; then
                found=$(find "$vol" -maxdepth 3 -name "*.app" -print -quit)
            fi
            if [ -z "$found" ] || [ ! -d "$found" ]; then
                hdiutil detach "$vol" -quiet 2>/dev/null || true
                log "ERRO: Cursor.app não encontrado no DMG"
                exit 1
            fi
            if [ -d "$CURSOR_APP" ]; then
                log "Substituindo instalação em $CURSOR_APP..."
                sudo rm -rf "$CURSOR_APP"
            fi
            log "Copiando para $CURSOR_APP..."
            sudo ditto "$found" "$CURSOR_APP"
            sudo xattr -dr com.apple.quarantine "$CURSOR_APP" 2>/dev/null || true
            hdiutil detach "$vol" -quiet 2>/dev/null || true
            return 0
            ;;
        *)
            if unzip -t "$archive" >/dev/null 2>&1; then
                mkdir -p "$tmp/extract"
                unzip -q -o "$archive" -d "$tmp/extract"
                found=$(find "$tmp/extract" -name "Cursor.app" -maxdepth 6 -print -quit)
            else
                log "ERRO: formato não reconhecido (esperado .zip ou .dmg)"
                exit 1
            fi
            ;;
    esac

    if [ -z "$found" ] || [ ! -d "$found" ]; then
        log "ERRO: Cursor.app não encontrado no pacote"
        exit 1
    fi

    if [ -d "$CURSOR_APP" ]; then
        log "Substituindo instalação em $CURSOR_APP..."
        sudo rm -rf "$CURSOR_APP"
    fi
    log "Copiando para $CURSOR_APP..."
    sudo ditto "$found" "$CURSOR_APP"
    sudo xattr -dr com.apple.quarantine "$CURSOR_APP" 2>/dev/null || true
}

configure_cli_symlink() {
    local cli
    cli=$(find_cursor_cli)
    if [ -z "$cli" ]; then
        log "AVISO: CLI 'cursor' não encontrada no .app; abra pelo Launchpad ou Spotlight."
        return 0
    fi
    sudo mkdir -p "$(dirname "$SYSTEM_BIN_LINK")"
    sudo rm -f "$SYSTEM_BIN_LINK"
    sudo ln -sf "$cli" "$SYSTEM_BIN_LINK"
    log "✓ Comando: $SYSTEM_BIN_LINK"
}

uninstall_cursor() {
    log "Removendo Cursor..."
    sudo rm -rf "$CURSOR_APP"
    sudo rm -f "$SYSTEM_BIN_LINK"
    log "✓ Removido."
    exit 0
}

install_once() {
    ensure_curl
    ensure_jq
    local url
    url=$(get_download_url)
    install_app_from_archive "$url"
    configure_cli_symlink
    log "=== Instalação concluída ==="
    log "O Cursor no macOS atualiza sozinho; use este script só para instalar ou reinstalar o pacote."
}

case "${1:-}" in
    --uninstall) uninstall_cursor ;;
    --help|-h) echo "Uso: $0 [--uninstall]"; echo "Sem opções: baixa e instala o Cursor em $CURSOR_APP." ;;
    *) install_once ;;
esac
