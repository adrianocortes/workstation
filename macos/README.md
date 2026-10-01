# macOS — Workstation

## Visão geral

Scripts e documentação para configurar um ambiente de desenvolvimento no **macOS** (Darwin), espelhando as capacidades do fluxo Ubuntu Desktop onde faz sentido.

## Requisitos

- macOS recente (testado conceitualmente em Apple Silicon e Intel)
- **Xcode Command Line Tools** (`xcode-select --install`) para `git` e ferramentas de build
- **Homebrew** (opcional mas recomendado): usado por iTerm2 e como caminho simples para o **jq**
- **jq**: instalável com `macos/scripts/install_jq.sh` (também roda no início do ambiente de terminal completo)
- Acesso à internet para downloads
- Para instalações em `/Applications` e `/usr/local/bin`, o script pode solicitar senha de administrador

## Estrutura

```
macos/
├── README.md
└── scripts/
    ├── install_arduino_ide.sh
    ├── install_cursor_ide.sh
    ├── install_iterm2.sh
    ├── install_ohmyzsh.sh
    ├── install_kubernetes_tools.sh
    ├── install_k9s.sh
    ├── install_all_terminal_environment.sh
    └── README.md
```

## Equivalências em relação ao Linux

| Linux (Ubuntu) | macOS |
|----------------|--------|
| Terminator | **iTerm2** (ou Terminal.app; ver `install_iterm2.sh`) |
| AppImage / `.desktop` | `.app` em `/Applications`, atalhos via Spotlight/Launchpad |
| `apt` | **Homebrew** (nos aliases do `.zshrc` gerado) |
| Grupo `dialout` / udev | Permissões de serial no macOS costumam funcionar após instalar o driver/board; ver notas no script Arduino |

## Como usar

Pelo repositório:

```bash
cd /caminho/para/workstation
./menu.sh
```

O menu detecta **Darwin** e mostra apenas as opções **macOS** implementadas nesta pasta.

Scripts também podem ser executados diretamente:

```bash
chmod +x macos/scripts/install_cursor_ide.sh
./macos/scripts/install_cursor_ide.sh
```
