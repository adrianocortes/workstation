#!/bin/bash

# Workstation Menu - Script Principal
# Versão: 1.0
# Autor: Workstation Project
# Data: $(date +%Y-%m-%d)
#
# Este script funciona como menu principal para gerenciar workstations
# Detecta automaticamente o sistema operacional e mostra opções relevantes

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para exibir cabeçalho
show_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    WORKSTATION MENU                         ║${NC}"
    echo -e "${CYAN}║              Gerenciador de Workstations                    ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Sistema Operacional Detectado: ${GREEN}$(uname -s) $(uname -r)${NC}"
    echo -e "${YELLOW}Arquitetura: ${GREEN}$(uname -m)${NC}"
    echo -e "${YELLOW}Usuário: ${GREEN}$USER${NC}"
    echo ""
}

# Função para exibir menu Linux
show_linux_menu() {
    echo -e "${BLUE}┌─ OPÇÕES DISPONÍVEIS PARA LINUX ─────────────────────────────┐${NC}"
    echo -e "${BLUE}│                                                          │${NC}"
    echo -e "${BLUE}│  ${GREEN}1)${NC} Ubuntu Desktop - Configurações e Scripts           ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}2)${NC} Ubuntu Server - Configurações e Scripts            ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}3)${NC} Ver Documentação Completa                          ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}4)${NC} Sobre o Projeto Workstation                        ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}0)${NC} Sair                                              ${BLUE}│${NC}"
    echo -e "${BLUE}│                                                          │${NC}"
    echo -e "${BLUE}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# Função para exibir submenu Ubuntu Desktop
show_ubuntu_desktop_menu() {
    echo -e "${PURPLE}┌─ UBUNTU DESKTOP - OPÇÕES DISPONÍVEIS ─────────────────────┐${NC}"
    echo -e "${PURPLE}│                                                          │${NC}"
    echo -e "${PURPLE}│  ${GREEN}1)${NC} Instalar Arduino IDE                              ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}2)${NC} Ambiente de Terminal Completo                     ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}3)${NC} Instalar Terminator                               ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}4)${NC} Instalar Zsh + Oh My Zsh                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}5)${NC} Instalar Ferramentas Kubernetes                   ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}6)${NC} Instalar k9s (Terminal UI para Kubernetes)        ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}7)${NC} Ver Scripts Disponíveis                           ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}8)${NC} Ver Configurações Disponíveis                     ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}9)${NC} Ver Documentação Ubuntu Desktop                   ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}0)${NC} Voltar ao Menu Principal                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│                                                          │${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# Função para exibir submenu Ubuntu Server
show_ubuntu_server_menu() {
    echo -e "${PURPLE}┌─ UBUNTU SERVER - OPÇÕES DISPONÍVEIS ─────────────────────┐${NC}"
    echo -e "${PURPLE}│                                                          │${NC}"
    echo -e "${PURPLE}│  ${GREEN}1)${NC} Ver Scripts Disponíveis                           ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}2)${NC} Ver Configurações Disponíveis                     ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}3)${NC} Ver Ferramentas Disponíveis                       ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}4)${NC} Ver Documentação Ubuntu Server                    ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}0)${NC} Voltar ao Menu Principal                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│                                                          │${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# Função para executar script Arduino IDE
install_arduino_ide() {
    echo -e "${YELLOW}Executando instalação do Arduino IDE...${NC}"
    echo ""

    SCRIPT_PATH="$(dirname "$0")/linux/Ubuntu/Desktop/scripts/install_arduino_ide.sh"

    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH"
    else
        echo -e "${RED}ERRO: Script Arduino IDE não encontrado em: $SCRIPT_PATH${NC}"
        echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
        read -r
    fi
}

# Função para listar scripts disponíveis
list_scripts() {
    local os_type="$1"
    echo -e "${YELLOW}Scripts Disponíveis para $os_type:${NC}"
    echo ""

    if [ "$os_type" = "Ubuntu Desktop" ]; then
        SCRIPT_DIR="$(dirname "$0")/linux/Ubuntu/Desktop/scripts"
    elif [ "$os_type" = "Ubuntu Server" ]; then
        SCRIPT_DIR="$(dirname "$0")/linux/Ubuntu/Server/scripts"
    fi

    if [ -d "$SCRIPT_DIR" ]; then
        if [ "$(ls -A "$SCRIPT_DIR" 2>/dev/null)" ]; then
            ls -la "$SCRIPT_DIR"/*.sh 2>/dev/null | while read -r line; do
                filename=$(basename "$(echo "$line" | awk '{print $NF}')")
                echo -e "  ${GREEN}•${NC} $filename"
            done
        else
            echo -e "  ${YELLOW}Nenhum script encontrado${NC}"
        fi
    else
        echo -e "  ${RED}Diretório de scripts não encontrado${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
    read -r
}

# Função para listar configurações disponíveis
list_configs() {
    local os_type="$1"
    echo -e "${YELLOW}Configurações Disponíveis para $os_type:${NC}"
    echo ""

    if [ "$os_type" = "Ubuntu Desktop" ]; then
        CONFIG_DIR="$(dirname "$0")/linux/Ubuntu/Desktop/configs"
    elif [ "$os_type" = "Ubuntu Server" ]; then
        CONFIG_DIR="$(dirname "$0")/linux/Ubuntu/Server/configs"
    fi

    if [ -d "$CONFIG_DIR" ]; then
        if [ "$(ls -A "$CONFIG_DIR" 2>/dev/null)" ]; then
            ls -la "$CONFIG_DIR"/* 2>/dev/null | while read -r line; do
                filename=$(basename "$(echo "$line" | awk '{print $NF}')")
                echo -e "  ${GREEN}•${NC} $filename"
            done
        else
            echo -e "  ${YELLOW}Nenhuma configuração encontrada${NC}"
        fi
    else
        echo -e "  ${RED}Diretório de configurações não encontrado${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
    read -r
}

# Função para listar ferramentas disponíveis
list_tools() {
    local os_type="$1"
    echo -e "${YELLOW}Ferramentas Disponíveis para $os_type:${NC}"
    echo ""

    TOOLS_DIR="$(dirname "$0")/linux/Ubuntu/Server/tools"

    if [ -d "$TOOLS_DIR" ]; then
        if [ "$(ls -A "$TOOLS_DIR" 2>/dev/null)" ]; then
            ls -la "$TOOLS_DIR"/* 2>/dev/null | while read -r line; do
                filename=$(basename "$(echo "$line" | awk '{print $NF}')")
                echo -e "  ${GREEN}•${NC} $filename"
            done
        else
            echo -e "  ${YELLOW}Nenhuma ferramenta encontrada${NC}"
        fi
    else
        echo -e "  ${RED}Diretório de ferramentas não encontrado${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
    read -r
}

# Função para mostrar documentação
show_documentation() {
    local doc_type="$1"
    echo -e "${YELLOW}Exibindo documentação para $doc_type...${NC}"
    echo ""

    if [ "$doc_type" = "Completa" ]; then
        DOC_PATH="$(dirname "$0")/docs/README.md"
    elif [ "$doc_type" = "Ubuntu Desktop" ]; then
        DOC_PATH="$(dirname "$0")/linux/Ubuntu/Desktop/README.md"
    elif [ "$doc_type" = "Ubuntu Server" ]; then
        DOC_PATH="$(dirname "$0")/linux/Ubuntu/Server/README.md"
    fi

    if [ -f "$DOC_PATH" ]; then
        if command -v less >/dev/null 2>&1; then
            less "$DOC_PATH"
        else
            cat "$DOC_PATH"
            echo ""
            echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
            read -r
        fi
    else
        echo -e "${RED}Documentação não encontrada em: $DOC_PATH${NC}"
        echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
        read -r
    fi
}

# Função para mostrar informações sobre o projeto
show_about() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    SOBRE O PROJETO                          ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Nome:${NC} Workstation"
    echo -e "${GREEN}Objetivo:${NC} Estruturar workstations de trabalho em diferentes áreas"
    echo -e "${GREEN}Versão:${NC} 1.0"
    echo -e "${GREEN}Autor:${NC} Workstation Project"
    echo ""
    echo -e "${YELLOW}Estrutura Atual:${NC}"
    echo -e "  ${GREEN}•${NC} Linux Ubuntu Desktop - Scripts e configurações"
    echo -e "  ${GREEN}•${NC} Linux Ubuntu Server - Scripts e configurações"
    echo -e "  ${GREEN}•${NC} Documentação completa"
    echo ""
    echo -e "${YELLOW}Recursos Disponíveis:${NC}"
    echo -e "  ${GREEN}•${NC} Instalador Arduino IDE (Ubuntu Desktop)"
    echo -e "  ${GREEN}•${NC} Menu interativo por sistema operacional"
    echo -e "  ${GREEN}•${NC} Documentação estruturada"
    echo ""
    echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
    read -r
}

# Função principal do menu
main_menu() {
    while true; do
        show_header
        show_linux_menu

        echo -e "${CYAN}Escolha uma opção: ${NC}"
        read -r choice

        case $choice in
            1)
                ubuntu_desktop_menu
                ;;
            2)
                ubuntu_server_menu
                ;;
            3)
                show_documentation "Completa"
                ;;
            4)
                show_about
                ;;
            0)
                echo -e "${GREEN}Obrigado por usar o Workstation Menu!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opção inválida! Pressione Enter para continuar...${NC}"
                read -r
                ;;
        esac
    done
}

# Função para executar script de terminal
run_terminal_script() {
    local script_name="$1"
    echo -e "${YELLOW}Executando $script_name...${NC}"
    echo ""

    SCRIPT_PATH="$(dirname "$0")/linux/Ubuntu/Desktop/scripts/$script_name"

    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH"
    else
        echo -e "${RED}ERRO: Script $script_name não encontrado em: $SCRIPT_PATH${NC}"
        echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
        read -r
    fi
}

# Função do menu Ubuntu Desktop
ubuntu_desktop_menu() {
    while true; do
        show_header
        show_ubuntu_desktop_menu

        echo -e "${CYAN}Escolha uma opção: ${NC}"
        read -r choice

        case $choice in
            1)
                install_arduino_ide
                ;;
            2)
                run_terminal_script "install_all_terminal_environment.sh"
                ;;
            3)
                run_terminal_script "install_terminator.sh"
                ;;
            4)
                run_terminal_script "install_ohmyzsh.sh"
                ;;
            5)
                run_terminal_script "install_kubernetes_tools.sh"
                ;;
            6)
                run_terminal_script "install_k9s.sh"
                ;;
            7)
                list_scripts "Ubuntu Desktop"
                ;;
            8)
                list_configs "Ubuntu Desktop"
                ;;
            9)
                show_documentation "Ubuntu Desktop"
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Opção inválida! Pressione Enter para continuar...${NC}"
                read -r
                ;;
        esac
    done
}

# Função do menu Ubuntu Server
ubuntu_server_menu() {
    while true; do
        show_header
        show_ubuntu_server_menu

        echo -e "${CYAN}Escolha uma opção: ${NC}"
        read -r choice

        case $choice in
            1)
                list_scripts "Ubuntu Server"
                ;;
            2)
                list_configs "Ubuntu Server"
                ;;
            3)
                list_tools "Ubuntu Server"
                ;;
            4)
                show_documentation "Ubuntu Server"
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Opção inválida! Pressione Enter para continuar...${NC}"
                read -r
                ;;
        esac
    done
}

# Verificar se está sendo executado no Linux
if [ "$(uname -s)" != "Linux" ]; then
    echo -e "${RED}ERRO: Este script é otimizado para sistemas Linux${NC}"
    echo -e "${YELLOW}Sistema detectado: $(uname -s)${NC}"
    exit 1
fi

# Executar menu principal
main_menu
