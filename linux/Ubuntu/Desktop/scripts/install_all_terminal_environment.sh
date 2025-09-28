#!/bin/bash

# Script para instalação completa do ambiente de terminal
# Versão: 1.0
# Autor: Workstation Project
# Data: $(date +%Y-%m-%d)
#
# Este script executa todos os scripts de terminal em sequência

set -e

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

log "=== Instalador Completo do Ambiente de Terminal ==="
log "Este script instalará:"
log "1. Terminator (terminal padrão + atalho Win+T)"
log "2. Zsh + Oh My Zsh (shell + plugins + tema)"
log "3. Ferramentas Kubernetes (kubectl, kubectx, krew, helm)"
log ""

# Obter diretório do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Instalar Terminator
log "=== ETAPA 1: Instalando Terminator ==="
if [ -f "$SCRIPT_DIR/install_terminator.sh" ]; then
    chmod +x "$SCRIPT_DIR/install_terminator.sh"
    "$SCRIPT_DIR/install_terminator.sh"
    log "✓ Terminator instalado com sucesso"
else
    log "ERRO: Script install_terminator.sh não encontrado"
    exit 1
fi

echo ""

# 2. Instalar Zsh + Oh My Zsh
log "=== ETAPA 2: Instalando Zsh + Oh My Zsh ==="
if [ -f "$SCRIPT_DIR/install_ohmyzsh.sh" ]; then
    chmod +x "$SCRIPT_DIR/install_ohmyzsh.sh"
    "$SCRIPT_DIR/install_ohmyzsh.sh"
    log "✓ Zsh + Oh My Zsh instalado com sucesso"
else
    log "ERRO: Script install_ohmyzsh.sh não encontrado"
    exit 1
fi

echo ""

# 3. Instalar Ferramentas Kubernetes
log "=== ETAPA 3: Instalando Ferramentas Kubernetes ==="
if [ -f "$SCRIPT_DIR/install_kubernetes_tools.sh" ]; then
    chmod +x "$SCRIPT_DIR/install_kubernetes_tools.sh"
    "$SCRIPT_DIR/install_kubernetes_tools.sh"
    log "✓ Ferramentas Kubernetes instaladas com sucesso"
else
    log "ERRO: Script install_kubernetes_tools.sh não encontrado"
    exit 1
fi

echo ""

# Finalização
log "=== INSTALAÇÃO COMPLETA CONCLUÍDA! ==="
log ""
log "✅ Terminator instalado e configurado como terminal padrão"
log "✅ Zsh e Oh My Zsh instalados com tema 'jonathan'"
log "✅ Ferramentas Kubernetes instaladas (kubectl, kubectx, krew, helm)"
log "✅ Atalho Win+T configurado para abrir terminal"
log ""
log "🎯 Configurações aplicadas:"
log "- Tema: jonathan"
log "- Plugins: git, kubectl, terraform, azure, ansible, helm, etc."
log "- Idioma: pt_BR.UTF-8"
log "- Terminator: Ubuntu Sans Mono 20"
log "- Atalhos: Shift+Alt+o/g/a para broadcast no Terminator"
log ""
log "📋 Próximos passos:"
log "1. Reinicie sua sessão para ativar o Zsh como shell padrão"
log "2. Teste o atalho Win+T para abrir o terminal"
log "3. Configure seus contextos do Kubernetes se necessário"
log ""
log "🔧 Para personalizar:"
log "- Edite ~/.zshrc para modificar plugins e configurações"
log "- Edite ~/.config/terminator/config para personalizar o Terminator"
log "- Execute 'omz plugin list' para ver todos os plugins disponíveis"
log ""
log "🚀 Ambiente de terminal profissional configurado com sucesso!"
