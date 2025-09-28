# Ubuntu Server - Configurações

## Visão Geral
Este diretório contém configurações e scripts para workstations baseados em Ubuntu Server.

## Estrutura

```
Server/
├── README.md           # Este arquivo
├── scripts/           # Scripts de configuração
├── configs/           # Arquivos de configuração
└── tools/             # Ferramentas e utilitários
```

## Configurações Disponíveis

### Scripts de Instalação
- [📋 Documentação dos Scripts](scripts/README.md)
- Configuração básica do sistema
- Instalação de pacotes essenciais
- Configuração de serviços

### Configurações de Sistema
- Configurações de rede
- Configurações de segurança
- Configurações de usuários

## Como Usar

### Via Menu Principal
Execute o menu principal do projeto:
```bash
cd /caminho/para/workstation
./menu.sh
```

### Via Scripts Diretos
1. Execute os scripts de configuração básica
2. Aplique as configurações específicas conforme necessário
3. Verifique se todos os serviços estão funcionando corretamente

## Requisitos

- Ubuntu Server 20.04 LTS ou superior
- Acesso root ou sudo
- Conexão com a internet para download de pacotes
