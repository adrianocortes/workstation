#!/bin/bash

# Script para instalação e configuração do Terminator
# Versão: 1.0
# Autor: Workstation Project
# Data: $(date +%Y-%m-%d)

set -e

# Configurações
TERMINATOR_CONFIG_DIR="$HOME/.config/terminator"

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

log "=== Instalador Terminator ==="
log "Iniciando instalação e configuração do Terminator..."

# Verificar e instalar dependências básicas
log "Verificando dependências..."
command -v curl >/dev/null 2>&1 || {
    log "curl é necessário mas não está instalado. Instalando...";
    sudo apt update && sudo apt install -y curl;
}

# Instalar Terminator
log "Instalando Terminator..."
sudo apt update
sudo apt install -y terminator

# Configurar Terminator como terminal padrão
log "Configurando Terminator como terminal padrão..."
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/terminator 50
sudo update-alternatives --set x-terminal-emulator /usr/bin/terminator

# Criar configuração personalizada do Terminator
log "Criando configuração personalizada do Terminator..."
mkdir -p "$TERMINATOR_CONFIG_DIR"

cat > "$TERMINATOR_CONFIG_DIR/config" <<'EOF'
[global_config]
  suppress_multiple_term_dialog = True

[keybindings]
  broadcast_off = <Shift><Alt>o
  broadcast_group = <Shift><Alt>g
  broadcast_all = <Shift><Alt>a

[profiles]
  [[default]]
    font = Ubuntu Sans Mono 20

[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0

[plugins]
EOF

# Configurar atalho Win+T
log "Configurando atalho Win+T para abrir terminal..."

# Detectar ambiente de desktop
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$DESKTOP_SESSION" = "gnome" ]; then
    log "Configurando atalho para GNOME..."
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'terminator'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>t'
elif [ "$XDG_CURRENT_DESKTOP" = "XFCE" ] || [ "$DESKTOP_SESSION" = "xfce" ]; then
    log "Configurando atalho para XFCE..."
    xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>t" -s "terminator"
elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$DESKTOP_SESSION" = "plasma" ]; then
    log "Configurando atalho para KDE..."
    kwriteconfig5 --file khotkeysrc --group "Data_2_2Triggers0" --key "Type" "GESTURE_SHORTCUT"
    kwriteconfig5 --file khotkeysrc --group "Data_2_2Actions0" --key "CommandURL" "terminator"
else
    log "AVISO: Ambiente de desktop não detectado. Configure manualmente o atalho Win+T"
fi

# Finalização
log "=== Instalação do Terminator Concluída! ==="
log "Terminator instalado e configurado como terminal padrão"
log "Atalho Win+T configurado para abrir terminal"
log "Configuração salva em: $TERMINATOR_CONFIG_DIR/config"
log ""
log "Para personalizar:"
log "- Edite ~/.config/terminator/config para modificar configurações"
log "- Teste o atalho Win+T para abrir o terminal"
