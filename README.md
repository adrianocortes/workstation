# Workstation

## Objetivo
Estruturar workstations de trabalho em diferentes áreas de atuação, fornecendo scripts, configurações e documentação para facilitar a configuração de ambientes de desenvolvimento e produção.

## Como Usar
Execute o menu principal para acessar as opções disponíveis:
```bash
./menu.sh
```

## Opções Disponíveis

### Linux
- **Ubuntu Desktop**: Scripts e configurações para desktops Ubuntu
  - [📋 Documentação Ubuntu Desktop](linux/Ubuntu/Desktop/README.md)
  - [🔧 Instalador Arduino IDE](linux/Ubuntu/Desktop/scripts/install_arduino_ide.sh)
  - [🔧 Instalador Cursor IDE](linux/Ubuntu/Desktop/scripts/install_cursor_ide.sh)
  - [🔧 Ambiente de Terminal Completo](linux/Ubuntu/Desktop/scripts/install_all_terminal_environment.sh)
  - [🔧 Instalador k9s](linux/Ubuntu/Desktop/scripts/install_k9s.sh)
  - [🔧 Scripts Modulares de Terminal](linux/Ubuntu/Desktop/scripts/README.md)

- **Ubuntu Server**: Scripts e configurações para servidores Ubuntu
  - [📋 Documentação Ubuntu Server](linux/Ubuntu/Server/README.md)

### Documentação
- [📚 Documentação Completa](docs/README.md)

## Estrutura do Projeto
```
workstation/
├── menu.sh                    # Menu principal interativo
├── docs/                      # Documentação geral
├── linux/
│   └── Ubuntu/
│       ├── Server/            # Configurações Ubuntu Server
│       └── Desktop/           # Configurações Ubuntu Desktop
│           ├── scripts/       # Scripts modulares
│           │   ├── install_arduino_ide.sh
│           │   ├── install_cursor_ide.sh
│           │   ├── install_terminator.sh
│           │   ├── install_ohmyzsh.sh
│           │   ├── install_kubernetes_tools.sh
│           │   ├── install_k9s.sh
│           │   └── install_all_terminal_environment.sh
│           ├── configs/       # Arquivos de configuração
│           ├── themes/        # Temas e personalizações
│           └── applications/  # Configurações de aplicações
```
