#!/bin/bash

# Script para instalação e configuração do Zsh + Oh My Zsh
# Versão: 1.0
# Autor: Workstation Project
# Data: $(date +%Y-%m-%d)

set -e

# Configurações
ZSH_CONFIG_FILE="$HOME/.zshrc"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

# =============================================================================
# CONFIGURAÇÕES PERSONALIZÁVEIS - MODIFIQUE AQUI PARA CUSTOMIZAR
# =============================================================================

# Tema do Oh My Zsh (exemplos: robbyrussell, agnoster, powerlevel10k/powerlevel10k)
ZSH_THEME="jonathan"

# Plugins do Oh My Zsh (adicione ou remova conforme necessário)
ZSH_PLUGINS=(
    "git"                    # Comandos git úteis
    "zsh-interactive-cd"     # Navegação interativa de diretórios
    "kube-ps1"              # Prompt do Kubernetes
    "sudo"                  # Duplo ESC para sudo
    "kubectl"               # Comandos kubectl úteis
    "kubectx"               # Troca de contexto Kubernetes
    "terraform"             # Comandos terraform úteis
    "web-search"            # Busca na web
    "zsh-autosuggestions"   # Sugestões baseadas no histórico
    "azure"                 # Comandos Azure CLI
    "ansible"               # Comandos Ansible
    "helm"                  # Comandos Helm
)

# Idioma do sistema (exemplos: pt_BR.UTF-8, en_US.UTF-8)
ZSH_LANGUAGE="pt_BR.UTF-8"

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

log "=== Instalador Zsh + Oh My Zsh ==="
log "Iniciando instalação e configuração do Zsh e Oh My Zsh..."

# Verificar e instalar dependências básicas
log "Verificando dependências..."
command -v curl >/dev/null 2>&1 || {
    log "curl é necessário mas não está instalado. Instalando...";
    sudo apt update && sudo apt install -y curl;
}
command -v git >/dev/null 2>&1 || {
    log "git é necessário mas não está instalado. Instalando...";
    sudo apt update && sudo apt install -y git;
}

# fzf removido - não é mais necessário sem zsh-interactive-cd

# Instalar Zsh
if ! command -v zsh >/dev/null 2>&1; then
    log "Instalando Zsh..."
    sudo apt update
    sudo apt install -y zsh

    # Verificar se Zsh foi instalado corretamente
    if ! command -v zsh >/dev/null 2>&1; then
        log "ERRO: Falha na instalação do Zsh"
        exit 1
    fi
    log "✓ Zsh instalado com sucesso"
else
    log "✓ Zsh já está instalado"
fi

# Instalar Oh My Zsh
log "Instalando Oh My Zsh..."
if [ -d "$OH_MY_ZSH_DIR" ]; then
    log "Oh My Zsh já está instalado. Atualizando..."
    cd "$OH_MY_ZSH_DIR" && git pull
else
    log "Instalando Oh My Zsh pela primeira vez..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Configurar Zsh como shell padrão
log "Configurando Zsh como shell padrão..."
if [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/bin/zsh" ]; then
    log "AVISO: Zsh não é o shell padrão atual ($SHELL)"
    log "Para alterar o shell padrão, execute manualmente: chsh -s /usr/bin/zsh"
    log "Ou reinicie a sessão e execute o Zsh manualmente"
else
    log "✓ Zsh já é o shell padrão"
fi

# Configurar Oh My Zsh com configurações otimizadas
log "Configurando Oh My Zsh com plugins e temas otimizados..."

# Backup do .zshrc existente
if [ -f "$ZSH_CONFIG_FILE" ]; then
    cp "$ZSH_CONFIG_FILE" "$ZSH_CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    log "Backup do .zshrc criado"
fi

# Criar configuração otimizada do Oh My Zsh
cat > "$ZSH_CONFIG_FILE" <<'EOF'
# Oh My Zsh Configuration
export ZSH="\$HOME/.oh-my-zsh"

# Tema (configurável no início do script)
ZSH_THEME="__ZSH_THEME__"

# Plugins (configuráveis no início do script)
plugins=(
    git
    kube-ps1
    sudo
    kubectl
    kubectx
    terraform
    web-search
    zsh-autosuggestions
    azure
    ansible
    helm
)

# Configurações do Oh My Zsh
DISABLE_AUTO_UPDATE="false"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

# Configurações do Zsh
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Aliases úteis
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias ports='netstat -tulanp'
alias myip='curl http://ipecho.net/plain; echo'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'
alias show='apt show'

# Funções úteis
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Carregar Oh My Zsh
source \$ZSH/oh-my-zsh.sh

# Configurações de PATH
export PATH="\$HOME/.local/bin:\$PATH"
export PATH="/usr/local/bin:\$PATH"

# Configurações de editor
export EDITOR='nano'
export VISUAL='nano'

# Configurações de linguagem (configurável no início do script)
export LANG="__ZSH_LANGUAGE__"
export LC_ALL="__ZSH_LANGUAGE__"

# Configurações específicas do Kubernetes (baseado na configuração atual)
export PATH="\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH"

# Configurar autocomplete do kubectl se disponível
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

# Configurações do kubectx (baseado na configuração atual)
if command -v kubectx >/dev/null 2>&1; then
    kubectx_mapping[context_name_from_kubeconfig]="\$emoji[wolf_face]"
    kubectx_mapping[production_cluster]="%{\$fg[yellow]%}prod!%{\$reset_color%}"
    kubectx_mapping[context\\ with\\ spaces]="%F{red}spaces%f"
fi
EOF

# Aplicar valores configuráveis sem expandir variáveis shell do conteúdo
sed -i "s|__ZSH_THEME__|$ZSH_THEME|g" "$ZSH_CONFIG_FILE"
sed -i "s|__ZSH_LANGUAGE__|$ZSH_LANGUAGE|g" "$ZSH_CONFIG_FILE"

# Instalar plugins adicionais do Oh My Zsh
log "Instalando plugins adicionais do Oh My Zsh..."

# zsh-autosuggestions
if [ ! -d "$OH_MY_ZSH_DIR/custom/plugins/zsh-autosuggestions" ]; then
    log "Instalando zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# kube-ps1
if [ ! -d "$OH_MY_ZSH_DIR/custom/plugins/kube-ps1" ]; then
    log "Instalando kube-ps1..."
    git clone https://github.com/jonmosco/kube-ps1.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kube-ps1
fi

# kubectl-autocomplete já está incluído no plugin kubectl padrão do Oh My Zsh

# Finalização
log "=== Instalação do Zsh + Oh My Zsh Concluída! ==="
log "Zsh e Oh My Zsh instalados e configurados"
log "Tema: jonathan"
log "Plugins: git, kubectl, terraform, azure, ansible, helm, etc."
log "Idioma: pt_BR.UTF-8"
log ""
log "Próximos passos:"
log "1. Reinicie sua sessão para ativar o Zsh como shell padrão"
log "2. Teste os plugins e aliases configurados"
log ""
log "Para personalizar:"
log "- Edite ~/.zshrc para modificar plugins e configurações"
log "- Execute 'omz plugin list' para ver todos os plugins disponíveis"
