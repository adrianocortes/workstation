#!/bin/bash
# Instala o jq no macOS (JSON na linha de comando).
set -e

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

if command -v jq >/dev/null 2>&1; then
    log "jq já instalado: $(command -v jq) ($(jq --version 2>&1))"
    exit 0
fi

if command -v brew >/dev/null 2>&1; then
    log "Instalando jq via Homebrew..."
    brew install jq
    log "✓ jq: $(command -v jq) ($(jq --version 2>&1))"
    exit 0
fi

ARCH=$(uname -m)
case "$ARCH" in
    arm64) JQ_ASSET="jq-macos-arm64" ;;
    x86_64) JQ_ASSET="jq-macos-amd64" ;;
    *)
        log "ERRO: Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

log "Homebrew não encontrado. Baixando jq (${JQ_ASSET}) do GitHub..."

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

TAG=$(curl -fsSL https://api.github.com/repos/jqlang/jq/releases/latest | grep '"tag_name"' | head -1 | cut -d'"' -f4)
[ -z "$TAG" ] && { log "ERRO: não foi possível obter a tag do jq"; exit 1; }

URL="https://github.com/jqlang/jq/releases/download/${TAG}/${JQ_ASSET}"
log "URL: $URL"
curl -fsSL "$URL" -o "$TMP/jq"
chmod +x "$TMP/jq"

sudo mkdir -p /usr/local/bin
sudo mv "$TMP/jq" /usr/local/bin/jq

log "✓ jq instalado em /usr/local/bin/jq ($(jq --version 2>&1))"
