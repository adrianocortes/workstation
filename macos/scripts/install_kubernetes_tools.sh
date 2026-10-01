#!/bin/bash
# Ferramentas Kubernetes — macOS (kubectl, kubectx, krew, helm)
set -e

KUBECTL_VERSION=""
INSTALL_KREW=true
INSTALL_HELM=true
CONFIGURE_AUTOCOMPLETE=true

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

command -v curl >/dev/null 2>&1 || { log "ERRO: curl necessário"; exit 1; }
command -v git >/dev/null 2>&1 || { log "ERRO: git necessário (xcode-select --install)"; exit 1; }

log "=== Instalador Ferramentas Kubernetes (macOS) ==="

ARCH=$(uname -m)
case $ARCH in
    x86_64) KUBECTL_ARCH="amd64" ;;
    arm64) KUBECTL_ARCH="arm64" ;;
    *)
        log "ERRO: Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

if ! command -v kubectl >/dev/null 2>&1; then
    log "Instalando kubectl ($KUBECTL_ARCH)..."
    if [ -n "$KUBECTL_VERSION" ]; then
        curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/darwin/$KUBECTL_ARCH/kubectl"
    else
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/$KUBECTL_ARCH/kubectl"
    fi
    sudo install -o root -g wheel -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
    log "✓ kubectl instalado"
else
    log "✓ kubectl já instalado"
fi

KUBECTX_DIR="/usr/local/kubectx"
if ! command -v kubectx >/dev/null 2>&1; then
    log "Instalando kubectx e kubens..."
    sudo mkdir -p "$(dirname "$KUBECTX_DIR")"
    if [ -d "$KUBECTX_DIR" ]; then
        sudo rm -rf "$KUBECTX_DIR"
    fi
    sudo git clone https://github.com/ahmetb/kubectx "$KUBECTX_DIR"
    sudo ln -sf "$KUBECTX_DIR/kubectx" /usr/local/bin/kubectx
    sudo ln -sf "$KUBECTX_DIR/kubens" /usr/local/bin/kubens
    log "✓ kubectx / kubens instalados"
else
    log "✓ kubectx já instalado"
fi

if [ "$INSTALL_KREW" = "true" ]; then
    if ! command -v kubectl-krew >/dev/null 2>&1; then
        log "Instalando krew..."
        (
            set -e
            cd "$(mktemp -d)"
            OS="$(uname | tr '[:upper:]' '[:lower:]')"
            KARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm64/arm64/')"
            KREW="krew-${OS}_${KARCH}"
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
            tar zxvf "${KREW}.tar.gz"
            ./"${KREW}" install krew
        )
        log "✓ krew instalado (adicione ao PATH: export PATH=\"\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH\")"
    else
        log "✓ krew já instalado"
    fi
fi

if [ "$INSTALL_HELM" = "true" ]; then
    if ! command -v helm >/dev/null 2>&1; then
        log "Instalando helm..."
        HELM_INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$HELM_INSTALL_DIR"
        HELM_VER=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
        [ -z "$HELM_VER" ] && HELM_VER="v3.16.0"
        cd /tmp
        curl -fsSLO "https://get.helm.sh/helm-${HELM_VER}-darwin-${KUBECTL_ARCH}.tar.gz"
        tar -xzf "helm-${HELM_VER}-darwin-${KUBECTL_ARCH}.tar.gz"
        mv "darwin-${KUBECTL_ARCH}/helm" "$HELM_INSTALL_DIR/helm"
        chmod +x "$HELM_INSTALL_DIR/helm"
        rm -rf "darwin-${KUBECTL_ARCH}" "helm-${HELM_VER}-darwin-${KUBECTL_ARCH}.tar.gz"
        log "✓ helm em $HELM_INSTALL_DIR/helm"
    else
        log "✓ helm já instalado"
    fi
fi

if [ "$CONFIGURE_AUTOCOMPLETE" = "true" ]; then
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "kubectl completion zsh" "$HOME/.zshrc"; then
            echo "" >> "$HOME/.zshrc"
            echo "# kubectl completion" >> "$HOME/.zshrc"
            echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >> "$HOME/.zshrc"
        fi
        if command -v helm >/dev/null 2>&1 && ! grep -q "helm completion zsh" "$HOME/.zshrc"; then
            echo '[[ $commands[helm] ]] && source <(helm completion zsh)' >> "$HOME/.zshrc"
        fi
    fi
fi

log "=== Concluído ==="
