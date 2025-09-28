# Scripts Ubuntu Server

## Visão Geral
Este diretório contém scripts independentes para configuração e instalação de serviços no Ubuntu Server.

## Scripts Disponíveis

*Nenhum script disponível no momento.*

## Execução Independente

Todos os scripts são independentes e podem ser executados diretamente:

```bash
# Executar script específico
cd /caminho/para/workstation/linux/Ubuntu/Server/scripts
./nome_do_script.sh

# Ou executar de qualquer lugar
/path/absoluto/para/workstation/linux/Ubuntu/Server/scripts/nome_do_script.sh
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

## Exemplos de Scripts Úteis

### Configuração Básica do Servidor
- Instalação de pacotes essenciais
- Configuração de firewall
- Configuração de SSH
- Configuração de usuários

### Serviços Web
- Instalação do Apache/Nginx
- Configuração de SSL
- Configuração de banco de dados
- Configuração de PHP/Python

### Monitoramento
- Instalação de ferramentas de monitoramento
- Configuração de logs
- Configuração de alertas
