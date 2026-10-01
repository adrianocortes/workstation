#!/bin/bash
# k9s — macOS
set -e

K9S_VERSION=""
K9S_INSTALL_DIR="$HOME/.local/bin"
CONFIGURE_ALIAS=true

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

command -v curl >/dev/null 2>&1 || { log "ERRO: curl necessário"; exit 1; }

ARCH=$(uname -m)
case $ARCH in
    x86_64) K9S_ARCH="amd64" ;;
    arm64) K9S_ARCH="arm64" ;;
    *)
        log "ERRO: Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

if ! command -v kubectl >/dev/null 2>&1; then
    log "AVISO: kubectl não encontrado. Instale install_kubernetes_tools.sh antes."
    read -r -p "Continuar mesmo assim? (y/N) " reply
    [[ "$reply" =~ ^[Yy]$ ]] || exit 1
fi

if [ -z "$K9S_VERSION" ]; then
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
fi
[ -z "$K9S_VERSION" ] && { log "ERRO: não foi possível obter a versão do k9s"; exit 1; }

DOWNLOAD_URL="https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Darwin_${K9S_ARCH}.tar.gz"
log "Baixando $DOWNLOAD_URL"

mkdir -p "$K9S_INSTALL_DIR"
TAR_NAME="k9s_Darwin_${K9S_ARCH}.tar.gz"
curl -fsSL "$DOWNLOAD_URL" -o "/tmp/$TAR_NAME"
tar -xzf "/tmp/$TAR_NAME" -C /tmp
chmod +x /tmp/k9s
mv /tmp/k9s "$K9S_INSTALL_DIR/k9s"
rm -f "/tmp/$TAR_NAME"

if [[ ":$PATH:" != *":$K9S_INSTALL_DIR:"* ]]; then
    echo "" >> "$HOME/.zshrc"
    echo "export PATH=\"$K9S_INSTALL_DIR:\$PATH\"" >> "$HOME/.zshrc"
fi

if [ "$CONFIGURE_ALIAS" = "true" ] && [ -f "$HOME/.zshrc" ] && ! grep -q "alias k9s=" "$HOME/.zshrc" 2>/dev/null; then
    echo "alias k9s='$K9S_INSTALL_DIR/k9s'" >> "$HOME/.zshrc"
fi

log "✓ k9s instalado em $K9S_INSTALL_DIR/k9s"
log "=== Concluído ==="
