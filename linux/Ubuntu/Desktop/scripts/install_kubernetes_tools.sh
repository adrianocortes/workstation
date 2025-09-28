#!/bin/bash

# Script para instalação de ferramentas Kubernetes
# Versão: 1.0
# Autor: Workstation Project
# Data: $(date +%Y-%m-%d)

set -e

# =============================================================================
# CONFIGURAÇÕES PERSONALIZÁVEIS - MODIFIQUE AQUI PARA CUSTOMIZAR
# =============================================================================

# Versão do kubectl (deixe vazio para usar a mais recente)
KUBECTL_VERSION=""  # Exemplo: "v1.28.0"

# Instalar krew (plugin manager do kubectl)
INSTALL_KREW=true

# Instalar helm
INSTALL_HELM=true

# Configurar autocomplete automaticamente
CONFIGURE_AUTOCOMPLETE=true

# =============================================================================
# FIM DAS CONFIGURAÇÕES PERSONALIZÁVEIS
# =============================================================================

# Função de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Função de limpeza em caso de erro
cleanup() {
    if [ $? -ne 0 ]; then
        log "Instalação falhou. Verifique os logs acima."
    fi
}
trap cleanup EXIT

log "=== Instalador Ferramentas Kubernetes ==="
log "Iniciando instalação das ferramentas Kubernetes..."

# Verificar e instalar dependências básicas
log "Verificando dependências..."
command -v curl >/dev/null 2>&1 || {
    log "curl é necessário mas não está instalado. Instalando...";
    sudo apt update && sudo apt install -y curl;
}
command -v wget >/dev/null 2>&1 || {
    log "wget é necessário mas não está instalado. Instalando...";
    sudo apt update && sudo apt install -y wget;
}
command -v git >/dev/null 2>&1 || {
    log "git é necessário mas não está instalado. Instalando...";
    sudo apt update && sudo apt install -y git;
}

# Detectar arquitetura para kubectl
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        KUBECTL_ARCH="amd64"
        ;;
    aarch64|arm64)
        KUBECTL_ARCH="arm64"
        ;;
    armv7l)
        KUBECTL_ARCH="arm"
        ;;
    *)
        log "ERRO: Arquitetura não suportada para kubectl: $ARCH"
        exit 1
        ;;
esac

# kubectl
if ! command -v kubectl >/dev/null 2>&1; then
    log "Instalando kubectl para arquitetura $ARCH ($KUBECTL_ARCH)..."
    if [ -n "$KUBECTL_VERSION" ]; then
        log "Instalando versão específica: $KUBECTL_VERSION"
        curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/$KUBECTL_ARCH/kubectl"
    else
        log "Instalando versão mais recente..."
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$KUBECTL_ARCH/kubectl"
    fi
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    log "✓ kubectl instalado"
else
    log "✓ kubectl já está instalado"
fi

# kubectx e kubens
if ! command -v kubectx >/dev/null 2>&1; then
    log "Instalando kubectx e kubens..."
    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
    log "✓ kubectx e kubens instalados"
else
    log "✓ kubectx já está instalado"
fi

# krew (plugin manager do kubectl)
if [ "$INSTALL_KREW" = "true" ]; then
    if ! command -v kubectl-krew >/dev/null 2>&1; then
        log "Instalando krew..."
        (
            set -x; cd "$(mktemp -d)" &&
            OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
            ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
            KREW="krew-${OS}_${ARCH}" &&
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
            tar zxvf "${KREW}.tar.gz" &&
            ./"${KREW}" install krew
        )
        export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        log "✓ krew instalado"
    else
        log "✓ krew já está instalado"
    fi
else
    log "⏭️ krew não será instalado (INSTALL_KREW=false)"
fi

# helm
if [ "$INSTALL_HELM" = "true" ]; then
    if ! command -v helm >/dev/null 2>&1; then
        log "Instalando helm..."

        # Instalar helm no diretório local do usuário (sem sudo)
        HELM_INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$HELM_INSTALL_DIR"

        # Obter versão mais recente
        HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
        if [ -z "$HELM_VERSION" ]; then
            HELM_VERSION="v3.19.0"  # Fallback para versão conhecida
        fi

        log "Baixando helm $HELM_VERSION..."
        cd /tmp
        curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-${KUBECTL_ARCH}.tar.gz"

        if [ -f "helm-${HELM_VERSION}-linux-${KUBECTL_ARCH}.tar.gz" ]; then
            tar -xzf "helm-${HELM_VERSION}-linux-${KUBECTL_ARCH}.tar.gz"
            mv linux-${KUBECTL_ARCH}/helm "$HELM_INSTALL_DIR/helm"
            chmod +x "$HELM_INSTALL_DIR/helm"
            rm -rf linux-${KUBECTL_ARCH} "helm-${HELM_VERSION}-linux-${KUBECTL_ARCH}.tar.gz"

            # Adicionar ao PATH se necessário
            if [[ ":$PATH:" != *":$HELM_INSTALL_DIR:"* ]]; then
                log "Adicionando $HELM_INSTALL_DIR ao PATH..."
                echo "" >> "$HOME/.bashrc"
                echo "# helm" >> "$HOME/.bashrc"
                echo "export PATH=\"$HELM_INSTALL_DIR:\$PATH\"" >> "$HOME/.bashrc"

                if [ -f "$HOME/.zshrc" ]; then
                    echo "" >> "$HOME/.zshrc"
                    echo "# helm" >> "$HOME/.zshrc"
                    echo "export PATH=\"$HELM_INSTALL_DIR:\$PATH\"" >> "$HOME/.zshrc"
                fi
            fi

            log "✓ helm instalado em $HELM_INSTALL_DIR/helm"
        else
            log "ERRO: Falha no download do helm"
            log "AVISO: helm não foi instalado. Você pode instalá-lo manualmente depois."
        fi
    else
        log "✓ helm já está instalado"
    fi
else
    log "⏭️ helm não será instalado (INSTALL_HELM=false)"
fi

# Verificar instalações
log "Verificando instalações..."

if command -v kubectl >/dev/null 2>&1; then
    KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null | cut -d' ' -f3 || echo "instalado")
    log "✓ kubectl: $KUBECTL_VERSION"
fi

if command -v kubectx >/dev/null 2>&1; then
    log "✓ kubectx: instalado"
fi

if command -v kubectl-krew >/dev/null 2>&1; then
    log "✓ krew: instalado"
fi

if command -v helm >/dev/null 2>&1; then
    HELM_VERSION=$(helm version --short 2>/dev/null | cut -d'+' -f1 || echo "instalado")
    log "✓ helm: $HELM_VERSION"
fi

# Configurar autocomplete
if [ "$CONFIGURE_AUTOCOMPLETE" = "true" ]; then
    log "Configurando autocomplete do kubectl e helm..."

# Adicionar autocomplete ao .zshrc se existir
if [ -f "$HOME/.zshrc" ]; then
    # Verificar se o autocomplete já está configurado
    if ! grep -q "kubectl completion zsh" "$HOME/.zshrc"; then
        log "Adicionando autocomplete do kubectl ao .zshrc..."
        echo "" >> "$HOME/.zshrc"
        echo "# Autocomplete do kubectl" >> "$HOME/.zshrc"
        echo "[[ \$commands[kubectl] ]] && source <(kubectl completion zsh)" >> "$HOME/.zshrc"
        log "✓ Autocomplete do kubectl configurado no .zshrc"
    else
        log "✓ Autocomplete do kubectl já está configurado no .zshrc"
    fi
fi

# Adicionar autocomplete ao .bashrc se existir
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "kubectl completion bash" "$HOME/.bashrc"; then
        log "Adicionando autocomplete do kubectl ao .bashrc..."
        echo "" >> "$HOME/.bashrc"
        echo "# Autocomplete do kubectl" >> "$HOME/.bashrc"
        echo "source <(kubectl completion bash)" >> "$HOME/.bashrc"
        log "✓ Autocomplete do kubectl configurado no .bashrc"
    else
        log "✓ Autocomplete do kubectl já está configurado no .bashrc"
    fi
fi

# Configurar autocomplete para helm
log "Configurando autocomplete do helm..."
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "helm completion zsh" "$HOME/.zshrc"; then
        echo "# Autocomplete do helm" >> "$HOME/.zshrc"
        echo "[[ \$commands[helm] ]] && source <(helm completion zsh)" >> "$HOME/.zshrc"
        log "✓ Autocomplete do helm configurado no .zshrc"
    else
        log "✓ Autocomplete do helm já está configurado no .zshrc"
    fi
fi

if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "helm completion bash" "$HOME/.bashrc"; then
        echo "# Autocomplete do helm" >> "$HOME/.bashrc"
        echo "source <(helm completion bash)" >> "$HOME/.bashrc"
        log "✓ Autocomplete do helm configurado no .bashrc"
    else
        log "✓ Autocomplete do helm já está configurado no .bashrc"
    fi
fi

# Finalização
log "=== Instalação das Ferramentas Kubernetes Concluída! ==="
log "Ferramentas instaladas:"
log "- kubectl: Cliente Kubernetes"
log "- kubectx/kubens: Troca de contexto e namespace"
log "- krew: Plugin manager do kubectl"
log "- helm: Gerenciador de pacotes Kubernetes"
log ""
log "Configurações aplicadas:"
log "- Autocomplete do kubectl configurado"
log "- Autocomplete do helm configurado"
log ""
log "Próximos passos:"
log "1. Reinicie o terminal ou execute 'source ~/.zshrc' para ativar autocomplete"
log "2. Configure seus contextos do Kubernetes se necessário"
log "3. Use 'kubectl config get-contexts' para ver contextos disponíveis"
log "4. Use 'kubectx' para trocar entre contextos"
log "5. Use 'kubectl krew list' para ver plugins disponíveis"
log ""
log "Para usar com Oh My Zsh:"
log "- Os plugins kubectl, kubectx e helm já estão configurados"
log "- Autocomplete funcionará automaticamente após reiniciar o terminal"
else
    log "⏭️ Autocomplete não será configurado (CONFIGURE_AUTOCOMPLETE=false)"
fi
