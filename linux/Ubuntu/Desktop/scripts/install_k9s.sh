#!/bin/bash

# Script para instalação e atualização do k9s
# Versão: 1.0
# Autor: Workstation Project
# Data: $(date +%Y-%m-%d)
#
# k9s é uma interface de terminal para Kubernetes que facilita a navegação,
# observação e gerenciamento de aplicações em clusters Kubernetes.

set -e

# =============================================================================
# CONFIGURAÇÕES PERSONALIZÁVEIS - MODIFIQUE AQUI PARA CUSTOMIZAR
# =============================================================================

# Versão do k9s (deixe vazio para usar a mais recente)
K9S_VERSION=""  # Exemplo: "v0.28.2"

# Diretório de instalação
K9S_INSTALL_DIR="$HOME/.local/bin"

# Configurar atalho no menu de aplicativos
CREATE_DESKTOP_ENTRY=true

# Configurar alias no shell
CONFIGURE_ALIAS=true

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

log "=== Instalador k9s ==="
log "k9s - Interface de terminal para Kubernetes"
log "Iniciando instalação/atualização do k9s..."

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

# Verificar se kubectl está instalado
if ! command -v kubectl >/dev/null 2>&1; then
    log "AVISO: kubectl não está instalado. k9s funciona melhor com kubectl."
    log "Execute o script install_kubernetes_tools.sh primeiro para instalar kubectl."
    read -p "Continuar mesmo assim? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Instalação cancelada pelo usuário"
        exit 1
    fi
fi

# Detectar arquitetura
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        K9S_ARCH="amd64"
        ;;
    aarch64|arm64)
        K9S_ARCH="arm64"
        ;;
    armv7l)
        K9S_ARCH="arm"
        ;;
    *)
        log "ERRO: Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

log "Arquitetura detectada: $ARCH ($K9S_ARCH)"

# Obter versão mais recente se não especificada
if [ -z "$K9S_VERSION" ]; then
    log "Buscando versão mais recente do k9s..."
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    if [ -z "$K9S_VERSION" ]; then
        log "ERRO: Não foi possível obter a versão mais recente"
        exit 1
    fi
    log "Versão mais recente encontrada: $K9S_VERSION"
else
    log "Usando versão especificada: $K9S_VERSION"
fi

# Verificar se já existe instalação
K9S_BINARY="$K9S_INSTALL_DIR/k9s"
if [ -f "$K9S_BINARY" ]; then
    CURRENT_VERSION=$($K9S_BINARY version --short 2>/dev/null | head -n1 | cut -d' ' -f2 || echo "desconhecida")
    log "k9s já está instalado. Versão atual: $CURRENT_VERSION"
    log "Atualizando para: $K9S_VERSION"
else
    log "Instalando k9s pela primeira vez..."
fi

# Criar diretório de instalação
mkdir -p "$K9S_INSTALL_DIR"

# Construir URL de download
DOWNLOAD_URL="https://github.com/derailed/k9s/releases/download/$K9S_VERSION/k9s_Linux_${K9S_ARCH}.tar.gz"
log "URL de download: $DOWNLOAD_URL"

# Download do k9s
log "Baixando k9s $K9S_VERSION..."
cd /tmp
wget -q "$DOWNLOAD_URL" -O "k9s_${K9S_VERSION}.tar.gz"

# Verificar se o download foi bem-sucedido
if [ ! -f "k9s_${K9S_VERSION}.tar.gz" ] || [ ! -s "k9s_${K9S_VERSION}.tar.gz" ]; then
    log "ERRO: Download falhou ou arquivo está vazio"
    exit 1
fi

# Extrair e instalar
log "Extraindo e instalando k9s..."
tar -xzf "k9s_${K9S_VERSION}.tar.gz"
chmod +x k9s
mv k9s "$K9S_BINARY"

# Verificar se a instalação foi bem-sucedida
if [ ! -f "$K9S_BINARY" ] || [ ! -x "$K9S_BINARY" ]; then
    log "ERRO: Falha na instalação do k9s"
    exit 1
fi

# Verificar versão instalada
INSTALLED_VERSION=$($K9S_BINARY version --short 2>/dev/null | head -n1 | cut -d' ' -f2 || echo "desconhecida")
log "✓ k9s instalado com sucesso! Versão: $INSTALLED_VERSION"

# Adicionar ao PATH se necessário
if [[ ":$PATH:" != *":$K9S_INSTALL_DIR:"* ]]; then
    log "Adicionando $K9S_INSTALL_DIR ao PATH..."
    echo "" >> "$HOME/.bashrc"
    echo "# k9s" >> "$HOME/.bashrc"
    echo "export PATH=\"$K9S_INSTALL_DIR:\$PATH\"" >> "$HOME/.bashrc"

    if [ -f "$HOME/.zshrc" ]; then
        echo "" >> "$HOME/.zshrc"
        echo "# k9s" >> "$HOME/.zshrc"
        echo "export PATH=\"$K9S_INSTALL_DIR:\$PATH\"" >> "$HOME/.zshrc"
    fi

    log "✓ PATH atualizado. Reinicie o terminal ou execute 'source ~/.bashrc'"
fi

# Configurar alias se solicitado
if [ "$CONFIGURE_ALIAS" = "true" ]; then
    log "Configurando alias para k9s..."

    # Adicionar alias ao .bashrc
    if ! grep -q "alias k9s=" "$HOME/.bashrc" 2>/dev/null; then
        echo "alias k9s='$K9S_BINARY'" >> "$HOME/.bashrc"
        log "✓ Alias adicionado ao .bashrc"
    fi

    # Adicionar alias ao .zshrc se existir
    if [ -f "$HOME/.zshrc" ] && ! grep -q "alias k9s=" "$HOME/.zshrc" 2>/dev/null; then
        echo "alias k9s='$K9S_BINARY'" >> "$HOME/.zshrc"
        log "✓ Alias adicionado ao .zshrc"
    fi
fi

# Criar atalho no menu de aplicativos se solicitado
if [ "$CREATE_DESKTOP_ENTRY" = "true" ]; then
    log "Criando atalho no menu de aplicativos..."

    DESKTOP_FILE="$HOME/.local/share/applications/k9s.desktop"
    mkdir -p "$(dirname "$DESKTOP_FILE")"

    cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=k9s
Comment=Terminal UI for Kubernetes
Exec=$K9S_BINARY
Icon=k9s
Terminal=true
Type=Application
Categories=Development;System;
Keywords=kubernetes;k8s;terminal;ui;
EOF

    # Baixar ícone
    ICON_PATH="$HOME/.local/share/icons/k9s.png"
    mkdir -p "$(dirname "$ICON_PATH")"

    # Tentar baixar ícone do k9s
    if ! wget -qO "$ICON_PATH" "https://raw.githubusercontent.com/derailed/k9s/master/assets/k9s.png" 2>/dev/null; then
        log "AVISO: Não foi possível baixar o ícone do k9s"
        rm -f "$ICON_PATH"
    else
        log "✓ Ícone baixado"
    fi

    # Atualizar cache de ícones
    update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
    log "✓ Atalho criado: $DESKTOP_FILE"
fi

# Limpeza
rm -f "/tmp/k9s_${K9S_VERSION}.tar.gz"

# Finalização
log "=== Instalação do k9s Concluída! ==="
log "k9s instalado em: $K9S_BINARY"
log "Versão: $INSTALLED_VERSION"
log ""
log "Como usar:"
log "  - Pelo terminal: k9s"
log "  - Pelo menu de aplicativos: k9s"
log "  - Com kubectl configurado: k9s --context <contexto>"
log ""
log "Comandos úteis do k9s:"
log "  - ':q' ou 'Ctrl+C' - Sair"
log "  - ':help' - Ajuda"
log "  - ':' - Comando"
log "  - '/' - Buscar"
log "  - 'd' - Descrever recurso"
log "  - 'e' - Editar recurso"
log "  - 'l' - Logs"
log "  - 's' - Shell"
log ""
log "Próximos passos:"
log "1. Reinicie o terminal para ativar o PATH e alias"
log "2. Execute 'k9s' para iniciar a interface"
log "3. Configure seu contexto Kubernetes se necessário"
log ""
log "Para atualizar no futuro:"
log "  - Execute este script novamente"
log "  - Ou modifique K9S_VERSION no início do script"
