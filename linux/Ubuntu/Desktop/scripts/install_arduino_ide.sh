#!/bin/bash
set -e

# Script para instalação da IDE Arduino no Ubuntu Desktop
# Versão: 2.0
# Autor: Workstation Project
# Data: $(date +%Y-%m-%d)
#
# Funcionalidades:
# - Download automático da versão mais recente
# - Criação de atalho no menu
# - Configuração de permissões USB
# - Verificação de dependências
# - Atualização automática se já existir

# Configurações
ARDUINO_VERSION="${ARDUINO_VERSION:-latest}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/arduino-ide}"
CREATE_DESKTOP_ENTRY="${CREATE_DESKTOP_ENTRY:-true}"
DOWNLOAD_ICON="${DOWNLOAD_ICON:-true}"

# Função de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Função de limpeza em caso de erro
cleanup() {
    if [ $? -ne 0 ]; then
        log "Instalação falhou. Removendo arquivos temporários..."
        rm -f "$FILENAME"
    fi
}
trap cleanup EXIT

# Função de desinstalação
uninstall_arduino() {
    log "Removendo Arduino IDE..."
    rm -f "$FILENAME"
    rm -f "$DESKTOP_FILE"
    rm -f "$ICON_PATH"
    log "Arduino IDE removido com sucesso!"
    exit 0
}

# Verificar argumentos
if [ "$1" = "--uninstall" ]; then
    uninstall_arduino
fi

log "=== Instalador Arduino IDE ==="
log "Iniciando instalação do Arduino IDE..."

# Verificar arquitetura
if [ "$(uname -m)" != "x86_64" ]; then
    log "AVISO: Este script é otimizado para arquitetura x86_64"
    log "Sua arquitetura: $(uname -m)"
    read -p "Continuar mesmo assim? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Instalação cancelada pelo usuário"
        exit 1
    fi
fi

# Verificar e instalar dependências
log "Verificando dependências..."
command -v curl >/dev/null 2>&1 || {
    log "curl é necessário mas não está instalado. Instalando...";
    sudo apt update && sudo apt install -y curl;
}
command -v wget >/dev/null 2>&1 || {
    log "wget é necessário mas não está instalado. Instalando...";
    sudo apt update && sudo apt install -y wget;
}

# Verificar se já existe instalação
FILENAME="$INSTALL_DIR/arduino-ide-latest.AppImage"
if [ -f "$FILENAME" ]; then
    log "Arduino IDE já está instalado em: $FILENAME"
    log "Atualizando para a versão mais recente..."
else
    log "Instalando Arduino IDE pela primeira vez..."
fi

# Descobre o link do AppImage mais recente via GitHub API
log "Buscando versão mais recente do Arduino IDE..."
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/arduino/arduino-ide/releases/$ARDUINO_VERSION \
  | grep "browser_download_url.*AppImage" \
  | cut -d '"' -f 4 \
  | grep -Ei "Linux.*64bit.*AppImage" | head -n1)

if [ -z "$DOWNLOAD_URL" ]; then
    log "ERRO: Não foi possível localizar o AppImage mais recente. Verifique sua conexão."
    exit 1
fi

# Criar diretório de instalação
mkdir -p "$INSTALL_DIR"

# Download do Arduino IDE
log "Baixando: $DOWNLOAD_URL"
curl -L "$DOWNLOAD_URL" -o "$FILENAME"

# Verificar se o download foi bem-sucedido
if [ ! -f "$FILENAME" ] || [ ! -s "$FILENAME" ]; then
    log "ERRO: Download falhou ou arquivo está vazio"
    exit 1
fi

# Verificar integridade do arquivo
if ! file "$FILENAME" | grep -q "AppImage"; then
    log "AVISO: O arquivo baixado pode não ser um AppImage válido"
fi

# Tornar executável
chmod +x "$FILENAME"
log "Arduino IDE baixado e configurado com sucesso!"

# Configurar permissões USB
log "Verificando permissões de acesso USB..."
if ! groups $USER | grep -q dialout; then
    log "Adicionando usuário ao grupo dialout para acesso serial..."
    sudo usermod -a -G dialout $USER
    log "IMPORTANTE: Reinicie a sessão para que as permissões tenham efeito"
else
    log "Usuário já está no grupo dialout - permissões USB OK"
fi

# Criar atalho no menu de aplicativos
if [ "$CREATE_DESKTOP_ENTRY" = "true" ]; then
    log "Criando atalho no menu de aplicativos..."
    DESKTOP_FILE="$HOME/.local/share/applications/arduino-ide.desktop"
    mkdir -p "$(dirname "$DESKTOP_FILE")"

    cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Arduino IDE
Comment=IDE para Arduino
Exec=$FILENAME --no-sandbox --disable-gpu --disable-dev-shm-usage
Icon=arduino-ide
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=arduino-ide
EOF
    log "Atalho criado: $DESKTOP_FILE"
fi

# Baixar ícone
if [ "$DOWNLOAD_ICON" = "true" ]; then
    log "Baixando ícone do Arduino IDE..."
    ICON_PATH="$HOME/.local/share/icons/arduino-ide.png"
    mkdir -p "$(dirname "$ICON_PATH")"

    # Tentar múltiplas fontes para o ícone
    if ! wget -qO "$ICON_PATH" "https://raw.githubusercontent.com/arduino/arduino-ide/main/resources/icons/arduino-ide.png" 2>/dev/null; then
        log "Tentando fonte alternativa para o ícone..."
        if ! wget -qO "$ICON_PATH" "https://raw.githubusercontent.com/arduino/arduino-ide/develop/resources/icons/arduino-ide.png" 2>/dev/null; then
            log "Usando ícone do Arduino da Wikipedia..."
            if ! wget -qO "$ICON_PATH" "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Arduino_Logo.svg/64px-Arduino_Logo.svg.png" 2>/dev/null; then
                log "Criando ícone genérico..."
                # Criar um ícone SVG simples como fallback
                cat > "$ICON_PATH" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
  <rect width="64" height="64" fill="#00979D" rx="8"/>
  <text x="32" y="40" font-family="Arial, sans-serif" font-size="24" font-weight="bold" text-anchor="middle" fill="white">A</text>
</svg>
EOF
            fi
        fi
    fi

    # Verificar se o ícone foi criado com sucesso
    if [ -s "$ICON_PATH" ]; then
        log "Ícone criado com sucesso: $ICON_PATH"
    else
        log "AVISO: Não foi possível criar o ícone"
        rm -f "$ICON_PATH"
    fi
fi

# Atualizar cache de ícones
log "Atualizando cache de ícones..."
update-desktop-database ~/.local/share/applications/ 2>/dev/null || true

# Finalização
log "=== Instalação Concluída! ==="
log "Arduino IDE instalado em: $FILENAME"
log "Para iniciar:"
log "  - Pelo menu de aplicativos: Arduino IDE"
log "  - Pelo terminal: $FILENAME"
log "  - Para desinstalar: $0 --uninstall"

if ! groups $USER | grep -q dialout; then
    log ""
    log "⚠️  LEMBRE-SE: Reinicie sua sessão para que as permissões USB tenham efeito!"
fi
