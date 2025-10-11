#!/bin/bash

# Script para instalação e atualização do Cursor IDE
# Versão: 1.0
# Autor: Workstation Project
# Data: $(date +%Y-%m-%d)
#
# Funcionalidades:
# - Instalação inicial completa
# - Atualização automática
# - Criação de atalho de desktop
# - Configuração de permissões para todos os usuários
# - Opção de desinstalação

set -e

# =============================================================================
# CONFIGURAÇÕES PERSONALIZÁVEIS - MODIFIQUE AQUI PARA CUSTOMIZAR
# =============================================================================

# Diretório de instalação (sistema)
CURSOR_INSTALL_DIR="/opt/cursor"

# URL da API oficial do Cursor
CURSOR_API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"

# Configurar atalho no menu de aplicativos
CREATE_DESKTOP_ENTRY=true

# Configurar PATH do sistema
CONFIGURE_SYSTEM_PATH=true

# Permitir acesso para todos os usuários
ALLOW_ALL_USERS=true

# =============================================================================
# FIM DAS CONFIGURAÇÕES PERSONALIZÁVEIS
# =============================================================================

# Arquivos e diretórios
VERSION_FILE="$CURSOR_INSTALL_DIR/current_version.txt"
DESKTOP_FILE="/usr/share/applications/cursor.desktop"
ICON_FILE="/usr/share/pixmaps/cursor.png"
SYSTEM_BIN_LINK="/usr/local/bin/cursor"

# Função de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Função de limpeza em caso de erro
cleanup() {
    if [ $? -ne 0 ]; then
        log "Instalação falhou. Verifique os logs acima."
        rm -f "$CURSOR_INSTALL_DIR/cursor.AppImage.tmp" 2>/dev/null || true
    fi
}
trap cleanup EXIT

# Função para verificar se é primeira instalação
is_first_install() {
    [ ! -f "$CURSOR_INSTALL_DIR/cursor.AppImage" ]
}

# Função para verificar dependências
check_dependencies() {
    log "Verificando dependências..."

    # Verificar curl
    if ! command -v curl >/dev/null 2>&1; then
        log "curl é necessário mas não está instalado. Instalando..."
        sudo apt update && sudo apt install -y curl
    fi

    # Verificar jq
    if ! command -v jq >/dev/null 2>&1; then
        log "jq é necessário mas não está instalado. Instalando..."
        sudo apt update && sudo apt install -y jq
    fi

    log "✓ Dependências verificadas"
}

# Função para criar estrutura de diretórios
create_directories() {
    log "Criando estrutura de diretórios..."

    # Criar diretório de instalação
    sudo mkdir -p "$CURSOR_INSTALL_DIR"

    # Configurar permissões para todos os usuários
    if [ "$ALLOW_ALL_USERS" = "true" ]; then
        sudo chmod 755 "$CURSOR_INSTALL_DIR"
        sudo chown root:root "$CURSOR_INSTALL_DIR"
    fi

    log "✓ Estrutura de diretórios criada"
}

# Função para obter informações da versão mais recente
get_latest_version_info() {
    log "Buscando versão mais recente do Cursor IDE..."

    # Buscar informações da API
    API_RESPONSE=$(curl -sL --connect-timeout 30 --max-time 60 "$CURSOR_API_URL")

    if [ $? -ne 0 ] || [ -z "$API_RESPONSE" ]; then
        log "ERRO: Falha ao conectar com a API do Cursor"
        exit 1
    fi

    # Extrair URL de download e versão
    DOWNLOAD_URL=$(echo "$API_RESPONSE" | jq -r '.downloadUrl' 2>/dev/null)
    LATEST_VERSION=$(echo "$API_RESPONSE" | jq -r '.version // .tag_name // "unknown"' 2>/dev/null)

    if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
        log "ERRO: Falha ao obter URL de download da API do Cursor"
        exit 1
    fi

    # Se não conseguir obter versão da API, usar URL como identificador
    if [[ -z "$LATEST_VERSION" || "$LATEST_VERSION" == "null" || "$LATEST_VERSION" == "unknown" ]]; then
        LATEST_VERSION=$(echo "$DOWNLOAD_URL" | grep -o '/[^/]*\.AppImage' | sed 's|/||' | sed 's|\.AppImage||')
    fi

    log "Versão mais recente encontrada: $LATEST_VERSION"
    echo "$DOWNLOAD_URL"
}

# Função para verificar versão atual
get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo ""
    fi
}

# Função para baixar e instalar Cursor
download_and_install() {
    local download_url="$1"
    local version="$2"

    log "Baixando Cursor IDE $version..."
    log "URL: $download_url"

    # Baixar para arquivo temporário
    if curl -L --fail --progress-bar -o "$CURSOR_INSTALL_DIR/cursor.AppImage.tmp" "$download_url"; then
        if [ -s "$CURSOR_INSTALL_DIR/cursor.AppImage.tmp" ]; then
            # Backup da versão anterior se existir
            if [ -f "$CURSOR_INSTALL_DIR/cursor.AppImage" ]; then
                log "Fazendo backup da versão anterior..."
                sudo mv "$CURSOR_INSTALL_DIR/cursor.AppImage" "$CURSOR_INSTALL_DIR/cursor.AppImage.backup"
            fi

            # Instalar nova versão
            sudo mv "$CURSOR_INSTALL_DIR/cursor.AppImage.tmp" "$CURSOR_INSTALL_DIR/cursor.AppImage"
            sudo chmod +x "$CURSOR_INSTALL_DIR/cursor.AppImage"

            # Salvar informação da versão
            echo "$version" | sudo tee "$VERSION_FILE" > /dev/null

            # Configurar permissões para todos os usuários
            if [ "$ALLOW_ALL_USERS" = "true" ]; then
                sudo chmod 755 "$CURSOR_INSTALL_DIR/cursor.AppImage"
                sudo chown root:root "$CURSOR_INSTALL_DIR/cursor.AppImage"
            fi

            log "✓ Cursor IDE instalado com sucesso!"
            log "Tamanho do arquivo: $(ls -lh "$CURSOR_INSTALL_DIR/cursor.AppImage" | awk '{print $5}')"

            # Limpar backup após instalação bem-sucedida
            sudo rm -f "$CURSOR_INSTALL_DIR/cursor.AppImage.backup"

            return 0
        else
            log "ERRO: Arquivo baixado está vazio"
            sudo rm -f "$CURSOR_INSTALL_DIR/cursor.AppImage.tmp"
            return 1
        fi
    else
        log "ERRO: Falha no download do Cursor IDE"
        sudo rm -f "$CURSOR_INSTALL_DIR/cursor.AppImage.tmp"
        return 1
    fi
}

# Função para criar atalho de desktop
create_desktop_entry() {
    if [ "$CREATE_DESKTOP_ENTRY" = "true" ]; then
        log "Criando atalho no menu de aplicativos..."

        # Baixar ícone se não existir
        if [ ! -f "$ICON_FILE" ]; then
            log "Baixando ícone do Cursor IDE..."
            if curl -sL -o "$ICON_FILE" "https://cursor.sh/favicon.ico" 2>/dev/null; then
                # Converter ICO para PNG se necessário
                if command -v convert >/dev/null 2>&1; then
                    convert "$ICON_FILE" "$ICON_FILE" 2>/dev/null || true
                fi
                log "✓ Ícone baixado"
            else
                log "AVISO: Não foi possível baixar o ícone. Usando ícone genérico."
                # Criar ícone SVG simples como fallback
                sudo tee "$ICON_FILE" > /dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
  <rect width="64" height="64" fill="#007ACC" rx="8"/>
  <text x="32" y="40" font-family="Arial, sans-serif" font-size="24" font-weight="bold" text-anchor="middle" fill="white">C</text>
</svg>
EOF
            fi
        fi

        # Criar arquivo .desktop
        sudo tee "$DESKTOP_FILE" > /dev/null <<EOF
[Desktop Entry]
Name=Cursor IDE
Comment=AI-powered code editor
Exec=$CURSOR_INSTALL_DIR/cursor.AppImage --no-sandbox
Icon=cursor
Terminal=false
Type=Application
Categories=Development;IDE;TextEditor;
Keywords=cursor;ide;editor;ai;code;
StartupWMClass=cursor
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/javascript;application/json;text/css;text/html;text/xml;text/x-sql;text/x-diff;
EOF

        # Configurar permissões
        sudo chmod 644 "$DESKTOP_FILE"
        sudo chmod 644 "$ICON_FILE"

        # Atualizar cache de ícones
        update-desktop-database /usr/share/applications/ 2>/dev/null || true

        log "✓ Atalho criado: $DESKTOP_FILE"
    fi
}

# Função para configurar PATH do sistema
configure_system_path() {
    if [ "$CONFIGURE_SYSTEM_PATH" = "true" ]; then
        log "Configurando PATH do sistema..."

        # Criar link simbólico em /usr/local/bin
        sudo ln -sf "$CURSOR_INSTALL_DIR/cursor.AppImage" "$SYSTEM_BIN_LINK"

        log "✓ PATH configurado. Cursor disponível como 'cursor' no terminal"
    fi
}

# Função para verificar instalação
verify_installation() {
    log "Verificando instalação..."

    if [ -f "$CURSOR_INSTALL_DIR/cursor.AppImage" ] && [ -x "$CURSOR_INSTALL_DIR/cursor.AppImage" ]; then
        local version=$(get_current_version)
        log "✓ Cursor IDE instalado com sucesso!"
        log "Versão: $version"
        log "Localização: $CURSOR_INSTALL_DIR/cursor.AppImage"

        if [ -f "$DESKTOP_FILE" ]; then
            log "✓ Atalho de desktop criado"
        fi

        if [ -L "$SYSTEM_BIN_LINK" ]; then
            log "✓ Comando 'cursor' disponível no terminal"
        fi

        return 0
    else
        log "ERRO: Instalação falhou"
        return 1
    fi
}

# Função de desinstalação
uninstall_cursor() {
    log "=== Desinstalando Cursor IDE ==="

    # Remover arquivos
    sudo rm -rf "$CURSOR_INSTALL_DIR"
    sudo rm -f "$DESKTOP_FILE"
    sudo rm -f "$ICON_FILE"
    sudo rm -f "$SYSTEM_BIN_LINK"

    # Atualizar cache de ícones
    update-desktop-database /usr/share/applications/ 2>/dev/null || true

    log "✓ Cursor IDE removido com sucesso!"
    exit 0
}

# Função para mostrar status
show_status() {
    log "=== Status do Cursor IDE ==="

    if [ -f "$CURSOR_INSTALL_DIR/cursor.AppImage" ]; then
        local version=$(get_current_version)
        log "Status: Instalado"
        log "Versão: $version"
        log "Localização: $CURSOR_INSTALL_DIR/cursor.AppImage"
        log "Tamanho: $(ls -lh "$CURSOR_INSTALL_DIR/cursor.AppImage" | awk '{print $5}')"

        if [ -f "$DESKTOP_FILE" ]; then
            log "Atalho de desktop: ✓"
        else
            log "Atalho de desktop: ✗"
        fi

        if [ -L "$SYSTEM_BIN_LINK" ]; then
            log "Comando 'cursor': ✓"
        else
            log "Comando 'cursor': ✗"
        fi
    else
        log "Status: Não instalado"
    fi
}

# Função principal de instalação/atualização
install_or_update() {
    local force_install="$1"

    # Verificar dependências
    check_dependencies

    # Criar estrutura de diretórios
    create_directories

    # Obter informações da versão mais recente
    local download_url=$(get_latest_version_info)
    local latest_version=$(echo "$download_url" | grep -o '/[^/]*\.AppImage' | sed 's|/||' | sed 's|\.AppImage||')

    # Verificar versão atual
    local current_version=$(get_current_version)

    if [ -n "$current_version" ]; then
        log "Versão atual: $current_version"
    else
        log "Primeira instalação detectada"
    fi

    # Verificar se precisa atualizar
    if [ "$force_install" = "true" ] || [ "$current_version" != "$latest_version" ] || is_first_install; then
        if [ "$current_version" != "$latest_version" ] && [ -n "$current_version" ]; then
            log "Nova versão disponível! Atualizando de '$current_version' para '$latest_version'"
        else
            log "Instalando Cursor IDE $latest_version..."
        fi

        # Baixar e instalar
        if download_and_install "$download_url" "$latest_version"; then
            # Criar atalho de desktop
            create_desktop_entry

            # Configurar PATH do sistema
            configure_system_path

            # Verificar instalação
            if verify_installation; then
                log "=== Instalação do Cursor IDE Concluída! ==="
                log ""
                log "Como usar:"
                log "  - Pelo terminal: cursor"
                log "  - Pelo menu de aplicativos: Cursor IDE"
                log "  - Para atualizar: Execute este script novamente"
                log ""
                log "Próximos passos:"
                log "1. Abra o Cursor IDE pelo menu ou terminal"
                log "2. Configure suas preferências"
                log "3. Instale extensões conforme necessário"
            else
                log "ERRO: Falha na verificação da instalação"
                exit 1
            fi
        else
            log "ERRO: Falha na instalação"
            exit 1
        fi
    else
        log "Cursor IDE já está atualizado (versão: $current_version)"
    fi
}

# Função para mostrar ajuda
show_help() {
    echo "Script de Instalação e Atualização do Cursor IDE"
    echo ""
    echo "Uso: $0 [OPÇÃO]"
    echo ""
    echo "Opções:"
    echo "  --install     Força instalação inicial"
    echo "  --update      Força atualização"
    echo "  --uninstall   Remove completamente o Cursor IDE"
    echo "  --status      Mostra status da instalação"
    echo "  --help        Mostra esta ajuda"
    echo ""
    echo "Sem opções: Instala ou atualiza automaticamente"
}

# Verificar argumentos
case "${1:-}" in
    --install)
        log "=== Instalador Cursor IDE ==="
        install_or_update "true"
        ;;
    --update)
        log "=== Atualizador Cursor IDE ==="
        install_or_update "true"
        ;;
    --uninstall)
        uninstall_cursor
        ;;
    --status)
        show_status
        ;;
    --help)
        show_help
        ;;
    "")
        log "=== Instalador/Atualizador Cursor IDE ==="
        install_or_update "false"
        ;;
    *)
        echo "Opção inválida: $1"
        show_help
        exit 1
        ;;
esac
