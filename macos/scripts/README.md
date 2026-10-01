# Scripts macOS

Instaladores para **Darwin**, alinhados conceitualmente ao fluxo Ubuntu Desktop.

| Script | Descrição |
|--------|-----------|
| `install_jq.sh` | **jq** — Homebrew ou binário oficial (`jq-macos-arm64` / `jq-macos-amd64`) em `/usr/local/bin` |
| `install_arduino_ide.sh` | Arduino IDE 2.x via `.dmg` (GitHub Releases) → `~/Applications` |
| `install_cursor_ide.sh` | Cursor: baixa o pacote estável e copia para `/Applications` (sem lógica de atualização; o app atualiza sozinho no Mac) |
| `install_iterm2.sh` | iTerm2 via Homebrew cask (equivalente ao Terminator no Linux) |
| `install_ohmyzsh.sh` | Zsh + Oh My Zsh + plugins (caminhos e aliases pensados para macOS) |
| `install_kubernetes_tools.sh` | kubectl, kubectx, krew, helm (binários `darwin`) |
| `install_k9s.sh` | k9s (`k9s_Darwin_*`) em `~/.local/bin` |
| `install_all_terminal_environment.sh` | Orquestra iTerm2 (melhor esforço) + Oh My Zsh + K8s + k9s |

Execução direta:

```bash
chmod +x install_cursor_ide.sh
./install_cursor_ide.sh
```

Ou use `./menu.sh` na raiz do repositório (em macOS, o menu mostra apenas o ramo **macOS**).
