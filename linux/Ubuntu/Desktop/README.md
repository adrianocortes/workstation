# Ubuntu Desktop - Configurações

## Visão Geral
Este diretório contém configurações e scripts para workstations baseados em Ubuntu Desktop.

## Estrutura

```
Desktop/
├── README.md           # Este arquivo
├── scripts/           # Scripts de configuração
├── configs/           # Arquivos de configuração
├── themes/            # Temas e personalizações
└── applications/      # Configurações de aplicações
```

## Configurações Disponíveis

### Scripts de Instalação
- **Arduino IDE**: Instalador automático da IDE Arduino
  - Download da versão mais recente via GitHub API
  - Configuração automática de permissões USB
  - Criação de atalho no menu de aplicativos
  - Atualização automática se já existir
  - Opção de desinstalação
  - [🔧 Executar Script](scripts/install_arduino_ide.sh)

- **Cursor IDE**: Instalador automático do editor de código com IA
  - Download da versão mais recente via API oficial
  - Instalação em /opt/cursor (sistema)
  - Permissões configuradas para todos os usuários
  - Criação de atalho no menu de aplicativos
  - Comando 'cursor' disponível no terminal
  - Atualização automática se já existir
  - Opção de desinstalação completa
  - [🔧 Executar Script](scripts/install_cursor_ide.sh)

- **Ambiente de Terminal**: Scripts modulares para configuração completa
  - **Terminator**: Terminal padrão com configurações personalizadas
  - **Zsh + Oh My Zsh**: Shell avançado com tema e plugins
  - **Ferramentas Kubernetes**: kubectl, kubectx, krew, helm
  - **k9s**: Terminal UI para Kubernetes
  - **Instalação Completa**: Todos os componentes de uma vez
  - [📋 Documentação dos Scripts](scripts/README.md)

- Configuração básica do sistema
- Instalação de aplicações essenciais
- Configuração do ambiente de desenvolvimento

### Personalização
- Temas e ícones
- Configurações do desktop
- Configurações de aplicações

### Aplicações
- Configurações do navegador
- Configurações de editores
- Configurações de ferramentas de desenvolvimento

## Como Usar

### Via Menu Principal
Execute o menu principal do projeto:
```bash
cd /caminho/para/workstation
./menu.sh
```

### Via Scripts Diretos
1. Execute os scripts de configuração básica
2. Aplique as personalizações desejadas
3. Configure as aplicações conforme necessário

### Exemplos de Uso

#### Arduino IDE
```bash
# Executar instalador Arduino IDE
./scripts/install_arduino_ide.sh

# Desinstalar Arduino IDE
./scripts/install_arduino_ide.sh --uninstall
```

#### Cursor IDE
```bash
# Instalar/Atualizar Cursor IDE
./scripts/install_cursor_ide.sh

# Forçar instalação inicial
./scripts/install_cursor_ide.sh --install

# Ver status da instalação
./scripts/install_cursor_ide.sh --status

# Desinstalar Cursor IDE
./scripts/install_cursor_ide.sh --uninstall
```

#### Ambiente de Terminal
```bash
# Instalação completa do ambiente
./scripts/install_all_terminal_environment.sh

# Instalações individuais
./scripts/install_terminator.sh
./scripts/install_ohmyzsh.sh
./scripts/install_kubernetes_tools.sh
./scripts/install_k9s.sh
```

## Requisitos

- Ubuntu Desktop 20.04 LTS ou superior
- Acesso sudo
- Conexão com a internet para download de pacotes
