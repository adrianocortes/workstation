# Scripts Ubuntu Desktop

## Visão Geral
Este diretório contém scripts independentes para configuração e instalação de aplicações no Ubuntu Desktop.

## Scripts Disponíveis

### install_arduino_ide.sh
Instalador automático da IDE Arduino com funcionalidades avançadas.

#### Uso Direto
```bash
# Instalar/Atualizar Arduino IDE
./install_arduino_ide.sh

# Desinstalar Arduino IDE
./install_arduino_ide.sh --uninstall
```

#### Funcionalidades
- ✅ Download automático da versão mais recente
- ✅ Configuração de permissões USB
- ✅ Criação de atalho no menu
- ✅ Atualização automática se já existir

### install_cursor_ide.sh
Instalador e atualizador do Cursor IDE (Editor de código com IA).

#### Uso Direto
```bash
# Instalar/Atualizar Cursor IDE
./install_cursor_ide.sh

# Forçar instalação inicial
./install_cursor_ide.sh --install

# Forçar atualização
./install_cursor_ide.sh --update

# Ver status da instalação
./install_cursor_ide.sh --status

# Desinstalar Cursor IDE
./install_cursor_ide.sh --uninstall
```

#### Funcionalidades
- ✅ Download automático da versão mais recente via API oficial
- ✅ Instalação em /opt/cursor (sistema)
- ✅ Permissões configuradas para todos os usuários
- ✅ Criação de atalho no menu de aplicativos
- ✅ Download automático do ícone
- ✅ Configuração de PATH do sistema
- ✅ Comando 'cursor' disponível no terminal
- ✅ Atualização automática se já existir
- ✅ Opção de desinstalação completa
- ✅ Verificação de dependências (curl, jq)
- ✅ Verificação de dependências
- ✅ Tratamento de erros robusto

### install_terminator.sh
Instalador e configurador do Terminator como terminal padrão.

#### Uso Direto
```bash
# Instalar e configurar Terminator
./install_terminator.sh
```

#### Funcionalidades
- ✅ Instalação do Terminator
- ✅ Configuração como terminal padrão
- ✅ Configuração personalizada (Ubuntu Sans Mono 20)
- ✅ Atalho Win+T para abrir terminal
- ✅ Atalhos de broadcast (Shift+Alt+o/g/a)

### install_ohmyzsh.sh
Instalador e configurador do Zsh + Oh My Zsh.

#### Uso Direto
```bash
# Instalar Zsh + Oh My Zsh
./install_ohmyzsh.sh
```

#### Funcionalidades
- ✅ Instalação do Zsh
- ✅ Instalação do Oh My Zsh
- ✅ Tema: jonathan
- ✅ Plugins: git, kubectl, terraform, azure, ansible, helm, kube-ps1, etc.
- ✅ Instalação automática de plugins externos (zsh-autosuggestions, kube-ps1)
- ✅ Idioma: pt_BR.UTF-8
- ✅ Configurações do kubectx
- ✅ Aliases e funções úteis

### install_kubernetes_tools.sh
Instalador de ferramentas Kubernetes.

#### Uso Direto
```bash
# Instalar ferramentas Kubernetes
./install_kubernetes_tools.sh
```

#### Funcionalidades
- ✅ kubectl (versão mais recente)
- ✅ kubectx e kubens
- ✅ krew (plugin manager)
- ✅ helm
- ✅ Verificação de instalações

### install_k9s.sh
Instalador e atualizador do k9s (Terminal UI para Kubernetes).

#### Uso Direto
```bash
# Instalar/Atualizar k9s
./install_k9s.sh
```

#### Funcionalidades
- ✅ Download automático da versão mais recente
- ✅ Detecção automática de arquitetura (amd64, arm64, arm)
- ✅ Instalação em ~/.local/bin
- ✅ Configuração de PATH automática
- ✅ Criação de alias no shell
- ✅ Atalho no menu de aplicativos
- ✅ Verificação de dependências (kubectl)
- ✅ Atualização automática se já existir

### install_all_terminal_environment.sh
Instalador completo do ambiente de terminal.

#### Uso Direto
```bash
# Instalar ambiente completo
./install_all_terminal_environment.sh
```

#### Funcionalidades
- ✅ Executa todos os scripts de terminal em sequência
- ✅ Instalação completa do ambiente
- ✅ Terminator + Zsh + Oh My Zsh + Ferramentas Kubernetes

#### Requisitos Gerais
- Ubuntu Desktop 20.04 LTS ou superior
- Acesso sudo
- Conexão com internet
- Arquitetura x86_64 (recomendado)

## Execução Independente

Todos os scripts são independentes e podem ser executados diretamente:

```bash
# Executar script específico
cd /caminho/para/workstation/linux/Ubuntu/Desktop/scripts
./nome_do_script.sh

# Ou executar de qualquer lugar
/path/absoluto/para/workstation/linux/Ubuntu/Desktop/scripts/nome_do_script.sh
```

## Via Menu Principal

Os scripts também podem ser executados através do menu principal:

```bash
cd /caminho/para/workstation
./menu.sh
```

## Adicionando Novos Scripts

Para adicionar novos scripts:

1. Crie o arquivo `.sh` neste diretório
2. Torne-o executável: `chmod +x nome_do_script.sh`
3. Documente no README.md
4. O menu principal detectará automaticamente
