#!/bin/bash
# Ambiente de terminal completo — macOS: iTerm2 (opcional) + Oh My Zsh + Kubernetes
set -e

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log "=== Ambiente de terminal (macOS) ==="
log "Etapa 1/5: jq"
chmod +x "$SCRIPT_DIR/install_jq.sh"
"$SCRIPT_DIR/install_jq.sh"

echo ""
log "Etapa 2/5: iTerm2 (ignora falha se não houver Homebrew)"
if [ -f "$SCRIPT_DIR/install_iterm2.sh" ]; then
    chmod +x "$SCRIPT_DIR/install_iterm2.sh"
    "$SCRIPT_DIR/install_iterm2.sh" || log "iTerm2 não instalado automaticamente — instale manualmente se quiser."
fi

echo ""
log "Etapa 3/5: Oh My Zsh"
chmod +x "$SCRIPT_DIR/install_ohmyzsh.sh"
"$SCRIPT_DIR/install_ohmyzsh.sh"

echo ""
log "Etapa 4/5: Ferramentas Kubernetes"
chmod +x "$SCRIPT_DIR/install_kubernetes_tools.sh"
"$SCRIPT_DIR/install_kubernetes_tools.sh"

echo ""
log "Etapa 5/5: k9s"
chmod +x "$SCRIPT_DIR/install_k9s.sh"
"$SCRIPT_DIR/install_k9s.sh"

log "=== Tudo concluído ==="
log "Reabra o Terminal ou execute: exec zsh"
