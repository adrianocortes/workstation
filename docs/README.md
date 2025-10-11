# Workstation - Documentação

## Visão Geral
Este projeto tem como objetivo estruturar workstations de trabalho para diferentes áreas de atuação.

## Estrutura do Projeto

```
workstation/
├── docs/                    # Documentação geral
├── linux/
│   └── Ubuntu/
│       ├── Server/          # Configurações para Ubuntu Server
│       └── Desktop/         # Configurações para Ubuntu Desktop
```

## Áreas de Trabalho

### Linux
- **Ubuntu Server**: Configurações e scripts para servidores Ubuntu
- **Ubuntu Desktop**: Configurações e scripts para desktops Ubuntu
  - **Arduino IDE**: Instalador automático com configurações avançadas
  - **Cursor IDE**: Instalador automático do editor de código com IA
  - **Ambiente de Terminal**: Scripts modulares para configuração completa
    - Terminator (terminal padrão)
    - Zsh + Oh My Zsh (shell avançado)
    - Ferramentas Kubernetes (kubectl, kubectx, krew, helm)
    - k9s (Terminal UI para Kubernetes)

## Como Usar

### Menu Principal
Execute o menu interativo para acessar todas as opções:
```bash
cd /caminho/para/workstation
./menu.sh
```

### Navegação Manual
1. Navegue até a área de trabalho desejada
2. Siga as instruções específicas de cada ambiente
3. Execute os scripts de configuração conforme necessário

### Recursos Disponíveis
- **Menu Interativo**: Interface amigável para todas as operações
- **Detecção Automática**: Mostra apenas opções do sistema operacional atual
- **Scripts Automatizados**: Instalação e configuração com um comando
- **Documentação Integrada**: Acesso rápido à documentação de cada recurso

## Contribuição

Para adicionar novas configurações ou melhorar as existentes, consulte a documentação específica de cada área de trabalho.
