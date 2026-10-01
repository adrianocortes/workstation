#!/bin/bash

# Workstation Menu — detecta o SO e exibe apenas opções disponíveis para o ambiente atual.

set -e

WS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

show_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    WORKSTATION MENU                         ║${NC}"
    echo -e "${CYAN}║              Gerenciador de Workstations                    ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Sistema:${NC} ${GREEN}$(uname -s) $(uname -r)${NC}  ${YELLOW}Arch:${NC} ${GREEN}$(uname -m)${NC}"
    echo -e "${YELLOW}Usuário:${NC} ${GREEN}$USER${NC}"
    echo ""
}

show_linux_main_menu() {
    echo -e "${BLUE}┌─ LINUX — OPÇÕES DISPONÍVEIS ────────────────────────────────┐${NC}"
    echo -e "${BLUE}│  ${GREEN}1)${NC} Ubuntu Desktop — scripts e configurações              ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}2)${NC} Ubuntu Server — scripts e configurações               ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}3)${NC} Documentação completa (docs/)                         ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}4)${NC} Sobre o projeto                                      ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}0)${NC} Sair                                                 ${BLUE}│${NC}"
    echo -e "${BLUE}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_macos_main_menu() {
    echo -e "${BLUE}┌─ macOS — OPÇÕES DISPONÍVEIS ────────────────────────────────┐${NC}"
    echo -e "${BLUE}│  ${GREEN}1)${NC} Ferramentas de desenvolvimento (scripts implementados)  ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}2)${NC} Documentação completa (docs/)                         ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}3)${NC} Sobre o projeto                                      ${BLUE}│${NC}"
    echo -e "${BLUE}│  ${GREEN}0)${NC} Sair                                                 ${BLUE}│${NC}"
    echo -e "${BLUE}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_ubuntu_desktop_menu() {
    echo -e "${PURPLE}┌─ UBUNTU DESKTOP — OPÇÕES ───────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│  ${GREEN}1)${NC} Instalar Arduino IDE                                  ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}2)${NC} Instalar Cursor IDE                                   ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}3)${NC} Ambiente de terminal completo                       ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}4)${NC} Instalar Terminator                                 ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}5)${NC} Instalar Zsh + Oh My Zsh                            ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}6)${NC} Instalar ferramentas Kubernetes                     ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}7)${NC} Instalar k9s                                        ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}8)${NC} Listar scripts disponíveis                          ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}9)${NC} Listar configurações disponíveis                    ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}10)${NC} Ver README Ubuntu Desktop                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}0)${NC} Voltar ao menu principal                           ${PURPLE}│${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_ubuntu_server_menu() {
    echo -e "${PURPLE}┌─ UBUNTU SERVER — OPÇÕES ────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│  ${GREEN}1)${NC} Listar scripts disponíveis                          ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}2)${NC} Listar configurações disponíveis                    ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}3)${NC} Listar ferramentas disponíveis                      ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}4)${NC} Ver README Ubuntu Server                           ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}0)${NC} Voltar ao menu principal                           ${PURPLE}│${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_macos_tools_menu() {
    echo -e "${PURPLE}┌─ macOS — FERRAMENTAS IMPLEMENTADAS ─────────────────────────┐${NC}"
    echo -e "${PURPLE}│  ${GREEN}1)${NC} Arduino IDE                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}2)${NC} Cursor IDE                                          ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}3)${NC} Ambiente de terminal completo (iTerm2+Zsh+K8s+k9s) ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}4)${NC} iTerm2                                              ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}5)${NC} Zsh + Oh My Zsh                                     ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}6)${NC} Ferramentas Kubernetes                              ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}7)${NC} k9s                                                 ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}8)${NC} Listar scripts em macos/scripts                     ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}9)${NC} Listar configs em macos/configs (se existir)         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}10)${NC} Ver README macOS                                   ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}11)${NC} Instalar jq                                        ${PURPLE}│${NC}"
    echo -e "${PURPLE}│  ${GREEN}0)${NC} Voltar ao menu principal                           ${PURPLE}│${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_other_os_menu() {
    echo -e "${YELLOW}┌─ SO NÃO SUPORTADO PELOS SCRIPTS DE AUTOMAÇÃO ───────────────┐${NC}"
    echo -e "${YELLOW}│  ${GREEN}1)${NC} Ver documentação em docs/README.md                  ${YELLOW}│${NC}"
    echo -e "${YELLOW}│  ${GREEN}2)${NC} Sobre o projeto                                     ${YELLOW}│${NC}"
    echo -e "${YELLOW}│  ${GREEN}0)${NC} Sair                                                ${YELLOW}│${NC}"
    echo -e "${YELLOW}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

install_arduino_ide() {
    echo -e "${YELLOW}Executando instalação do Arduino IDE...${NC}"
    echo ""
    local SCRIPT_PATH="$WS_ROOT/linux/Ubuntu/Desktop/scripts/install_arduino_ide.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH"
    else
        echo -e "${RED}ERRO: Script não encontrado: $SCRIPT_PATH${NC}"
        echo -e "${YELLOW}Pressione Enter...${NC}"
        read -r
    fi
}

list_scripts_dir() {
    local label="$1"
    local SCRIPT_DIR="$2"
    echo -e "${YELLOW}Scripts — $label${NC}"
    echo ""
    if [ -d "$SCRIPT_DIR" ] && [ "$(ls -A "$SCRIPT_DIR"/*.sh 2>/dev/null)" ]; then
        for f in "$SCRIPT_DIR"/*.sh; do
            [ -f "$f" ] || continue
            echo -e "  ${GREEN}•${NC} $(basename "$f")"
        done
    else
        echo -e "  ${YELLOW}Nenhum script .sh encontrado${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Pressione Enter...${NC}"
    read -r
}

list_configs_dir() {
    local label="$1"
    local CONFIG_DIR="$2"
    echo -e "${YELLOW}Configurações — $label${NC}"
    echo ""
    if [ -d "$CONFIG_DIR" ] && [ "$(ls -A "$CONFIG_DIR" 2>/dev/null)" ]; then
        ls -1 "$CONFIG_DIR" | while read -r name; do
            echo -e "  ${GREEN}•${NC} $name"
        done
    else
        echo -e "  ${YELLOW}Nenhuma configuração encontrada (pasta ausente ou vazia)${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Pressione Enter...${NC}"
    read -r
}

list_tools() {
    echo -e "${YELLOW}Ferramentas — Ubuntu Server${NC}"
    echo ""
    local TOOLS_DIR="$WS_ROOT/linux/Ubuntu/Server/tools"
    if [ -d "$TOOLS_DIR" ] && [ "$(ls -A "$TOOLS_DIR" 2>/dev/null)" ]; then
        ls -la "$TOOLS_DIR"/* 2>/dev/null | while read -r line; do
            filename=$(basename "$(echo "$line" | awk '{print $NF}')")
            echo -e "  ${GREEN}•${NC} $filename"
        done
    else
        echo -e "  ${YELLOW}Nenhuma ferramenta encontrada${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Pressione Enter...${NC}"
    read -r
}

show_documentation() {
    local doc_type="$1"
    echo -e "${YELLOW}Documentação: $doc_type${NC}"
    echo ""
    local DOC_PATH=""
    case "$doc_type" in
        Completa) DOC_PATH="$WS_ROOT/docs/README.md" ;;
        Ubuntu\ Desktop) DOC_PATH="$WS_ROOT/linux/Ubuntu/Desktop/README.md" ;;
        Ubuntu\ Server) DOC_PATH="$WS_ROOT/linux/Ubuntu/Server/README.md" ;;
        macOS) DOC_PATH="$WS_ROOT/macos/README.md" ;;
    esac
    if [ -f "$DOC_PATH" ]; then
        if command -v less >/dev/null 2>&1; then
            less "$DOC_PATH"
        else
            cat "$DOC_PATH"
            echo ""
            echo -e "${YELLOW}Pressione Enter...${NC}"
            read -r
        fi
    else
        echo -e "${RED}Arquivo não encontrado: $DOC_PATH${NC}"
        echo -e "${YELLOW}Pressione Enter...${NC}"
        read -r
    fi
}

show_about() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    SOBRE O PROJETO                          ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Nome:${NC} Workstation"
    echo -e "${GREEN}Objetivo:${NC} Scripts e documentação para ambientes de desenvolvimento."
    echo -e "${GREEN}Plataformas:${NC} Linux (Ubuntu Desktop/Server), macOS (scripts em macos/)."
    echo ""
    echo -e "${YELLOW}Pressione Enter...${NC}"
    read -r
}

run_linux_desktop_script() {
    local script_name="$1"
    local SCRIPT_PATH="$WS_ROOT/linux/Ubuntu/Desktop/scripts/$script_name"
    echo -e "${YELLOW}Executando $script_name...${NC}"
    echo ""
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH"
    else
        echo -e "${RED}ERRO: Script não encontrado: $SCRIPT_PATH${NC}"
        echo -e "${YELLOW}Pressione Enter...${NC}"
        read -r
    fi
}

run_macos_script() {
    local script_name="$1"
    local SCRIPT_PATH="$WS_ROOT/macos/scripts/$script_name"
    echo -e "${YELLOW}Executando $script_name...${NC}"
    echo ""
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH"
    else
        echo -e "${RED}ERRO: Script não implementado ou ausente: $SCRIPT_PATH${NC}"
        echo -e "${YELLOW}Pressione Enter...${NC}"
        read -r
    fi
}

main_menu_linux() {
    while true; do
        show_header
        show_linux_main_menu
        echo -e "${CYAN}Escolha: ${NC}"
        read -r choice
        case $choice in
            1) ubuntu_desktop_menu ;;
            2) ubuntu_server_menu ;;
            3) show_documentation "Completa" ;;
            4) show_about ;;
            0)
                echo -e "${GREEN}Até logo.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                read -r
                ;;
        esac
    done
}

ubuntu_desktop_menu() {
    while true; do
        show_header
        show_ubuntu_desktop_menu
        echo -e "${CYAN}Escolha: ${NC}"
        read -r choice
        case $choice in
            1) install_arduino_ide ;;
            2) run_linux_desktop_script "install_cursor_ide.sh" ;;
            3) run_linux_desktop_script "install_all_terminal_environment.sh" ;;
            4) run_linux_desktop_script "install_terminator.sh" ;;
            5) run_linux_desktop_script "install_ohmyzsh.sh" ;;
            6) run_linux_desktop_script "install_kubernetes_tools.sh" ;;
            7) run_linux_desktop_script "install_k9s.sh" ;;
            8) list_scripts_dir "Ubuntu Desktop" "$WS_ROOT/linux/Ubuntu/Desktop/scripts" ;;
            9) list_configs_dir "Ubuntu Desktop" "$WS_ROOT/linux/Ubuntu/Desktop/configs" ;;
            10) show_documentation "Ubuntu Desktop" ;;
            0) return ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                read -r
                ;;
        esac
    done
}

ubuntu_server_menu() {
    while true; do
        show_header
        show_ubuntu_server_menu
        echo -e "${CYAN}Escolha: ${NC}"
        read -r choice
        case $choice in
            1) list_scripts_dir "Ubuntu Server" "$WS_ROOT/linux/Ubuntu/Server/scripts" ;;
            2) list_configs_dir "Ubuntu Server" "$WS_ROOT/linux/Ubuntu/Server/configs" ;;
            3) list_tools ;;
            4) show_documentation "Ubuntu Server" ;;
            0) return ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                read -r
                ;;
        esac
    done
}

macos_tools_menu() {
    while true; do
        show_header
        show_macos_tools_menu
        echo -e "${CYAN}Escolha: ${NC}"
        read -r choice
        case $choice in
            1) run_macos_script "install_arduino_ide.sh" ;;
            2) run_macos_script "install_cursor_ide.sh" ;;
            3) run_macos_script "install_all_terminal_environment.sh" ;;
            4) run_macos_script "install_iterm2.sh" ;;
            5) run_macos_script "install_ohmyzsh.sh" ;;
            6) run_macos_script "install_kubernetes_tools.sh" ;;
            7) run_macos_script "install_k9s.sh" ;;
            8) list_scripts_dir "macOS" "$WS_ROOT/macos/scripts" ;;
            9) list_configs_dir "macOS" "$WS_ROOT/macos/configs" ;;
            10) show_documentation "macOS" ;;
            11) run_macos_script "install_jq.sh" ;;
            0) return ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                read -r
                ;;
        esac
    done
}

main_menu_macos() {
    while true; do
        show_header
        show_macos_main_menu
        echo -e "${CYAN}Escolha: ${NC}"
        read -r choice
        case $choice in
            1) macos_tools_menu ;;
            2) show_documentation "Completa" ;;
            3) show_about ;;
            0)
                echo -e "${GREEN}Até logo.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                read -r
                ;;
        esac
    done
}

main_menu_other() {
    while true; do
        show_header
        echo -e "${RED}Este sistema ($(uname -s)) não possui scripts de automação neste repositório.${NC}"
        echo ""
        show_other_os_menu
        echo -e "${CYAN}Escolha: ${NC}"
        read -r choice
        case $choice in
            1) show_documentation "Completa" ;;
            2) show_about ;;
            0)
                echo -e "${GREEN}Até logo.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                read -r
                ;;
        esac
    done
}

case "$(uname -s)" in
    Linux)
        main_menu_linux
        ;;
    Darwin)
        main_menu_macos
        ;;
    *)
        main_menu_other
        ;;
esac
