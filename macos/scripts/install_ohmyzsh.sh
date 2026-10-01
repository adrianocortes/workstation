#!/bin/bash
# Zsh + Oh My Zsh — macOS
set -e

ZSH_CONFIG_FILE="$HOME/.zshrc"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_THEME="jonathan"
ZSH_LANGUAGE="pt_BR.UTF-8"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

ensure_brew_zsh() {
    if command -v zsh >/dev/null 2>&1 && [ -x "$(command -v zsh)" ]; then
        log "✓ zsh já disponível: $(command -v zsh)"
        return 0
    fi
    if command -v brew >/dev/null 2>&1; then
        log "Instalando zsh via Homebrew..."
        brew install zsh
        return 0
    fi
    log "ERRO: Instale zsh ou Homebrew (https://brew.sh)."
    exit 1
}

log "=== Instalador Zsh + Oh My Zsh (macOS) ==="

command -v curl >/dev/null 2>&1 || { log "ERRO: curl necessário (instale Xcode CLT)"; exit 1; }
command -v git >/dev/null 2>&1 || { log "ERRO: git necessário (xcode-select --install)"; exit 1; }

ensure_brew_zsh

log "Instalando / atualizando Oh My Zsh..."
if [ -d "$OH_MY_ZSH_DIR" ]; then
    (cd "$OH_MY_ZSH_DIR" && git pull --ff-only) || log "AVISO: git pull falhou; continuando"
else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ -f "$ZSH_CONFIG_FILE" ]; then
    cp "$ZSH_CONFIG_FILE" "$ZSH_CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    log "Backup do .zshrc criado"
fi

cat > "$ZSH_CONFIG_FILE" <<'EOF'
# Oh My Zsh — macOS (workstation)
[[ -d /opt/homebrew ]] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="__ZSH_THEME__"

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

DISABLE_AUTO_UPDATE="false"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_VERIFY SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias h='history'
alias path='echo -e ${PATH//:/\\n}'

if command -v brew >/dev/null 2>&1; then
    alias brewup='brew update && brew upgrade'
    alias bi='brew install'
    alias bs='brew search'
fi

mkcd() { mkdir -p "$1" && cd "$1"; }

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

export EDITOR="${EDITOR:-nano}"
export VISUAL="${VISUAL:-nano}"

export LANG="__ZSH_LANGUAGE__"
export LC_ALL="__ZSH_LANGUAGE__"

export PATH="\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH"

if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

if command -v kubectx >/dev/null 2>&1; then
    kubectx_mapping[context_name_from_kubeconfig]="\$emoji[wolf_face]"
    kubectx_mapping[production_cluster]="%{\$fg[yellow]%}prod!%{\$reset_color%}"
    kubectx_mapping[context\\ with\\ spaces]="%F{red}spaces%f"
fi
EOF

sed -i '' "s|__ZSH_THEME__|$ZSH_THEME|g" "$ZSH_CONFIG_FILE"
sed -i '' "s|__ZSH_LANGUAGE__|$ZSH_LANGUAGE|g" "$ZSH_CONFIG_FILE"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$OH_MY_ZSH_DIR/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$OH_MY_ZSH_DIR/custom/plugins/kube-ps1" ]; then
    git clone https://github.com/jonmosco/kube-ps1.git "$ZSH_CUSTOM/plugins/kube-ps1"
fi

ZSH_PATH="$(command -v zsh)"
log "Shell padrão atual: $SHELL"
log "Para definir zsh como padrão: chsh -s $ZSH_PATH"
log "=== Concluído ==="
