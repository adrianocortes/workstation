#!/bin/bash
# Instala o iTerm2 no macOS (equivalente prático ao Terminator no Linux).
set -e

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

log "=== Instalador iTerm2 ==="

if command -v brew >/dev/null 2>&1; then
    log "Homebrew detectado. Instalando iTerm2 via cask..."
    brew install --cask iterm2
    log "✓ iTerm2 instalado. Abra pelo Spotlight ou Aplicativos."
    exit 0
fi

log "Homebrew não encontrado."
log "Opções:"
log "  1) Instale Homebrew: https://brew.sh"
log "  2) Baixe o iTerm2 manualmente: https://iterm2.com/downloads.html"
exit 1
