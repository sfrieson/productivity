# Productivity

A list of tools that help me stay _consistently_ productive between machines.

## Git

Settings

```bash
git config --global core.editor nano
git config --global --edit
```

## OMZ Plugin

### Installation

1) Clone repo
1) Open `~/.zshrc`
1) Change the `ZSH_CUSTOM` entry to point to this repo's `zsh_custom` directory
1) Add this line before the plugins to autoload the node version from an .nvmrc file: `NVM_AUTOLOAD=1`.
1) Add the plugins from this repo and turn on others: `plugins=(git sfrieson sfrieson-git nvm)` 
