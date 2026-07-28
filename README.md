# Dotfiles

My development environment configuration using [Dotbot](https://github.com/anishathalye/dotbot).

## Contents

- **nvim** - Neovim configuration with Lazy.nvim, Telescope, LSP, and Elixir tooling
- **ghostty** - Ghostty terminal configuration
- **wezterm** - WezTerm terminal configuration
- **lazygit** - Lazygit configuration with GitHub integration commands
- **zshrc** - Zsh configuration with oh-my-zsh
- **bin** - Utility scripts for git workflows

## Dependencies

- [dotbot](https://github.com/anishathalye/dotbot) - Dotfiles manager
- [Neovim](https://neovim.io/) - Text editor
- [Ghostty](https://ghostty.org/) - Terminal emulator
- [WezTerm](https://wezterm.org/) - Terminal emulator
- [lazygit](https://github.com/jesseduffield/lazygit) - Git TUI
- [gh](https://cli.github.com/) - GitHub CLI (for lazygit custom commands)
- [oh-my-zsh](https://ohmyz.sh/) - Zsh framework
- [ezza](https://eza.rocks/) - Eza

## Install

First, install dotbot:

```sh
pipx install dotbot
```

Then clone and run:

```sh
git clone git@github.com:archr/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

## Symlinks

This creates symlinks for:

- `~/.config/nvim/init.lua` - Neovim config
- `~/.config/ghostty/config` - Ghostty config
- `~/.wezterm.lua` - WezTerm config
- `~/Library/Application Support/lazygit/config.yml` - Lazygit config
- `~/.zshrc` - Zsh config
- `~/.local/bin/` - Utility scripts

## Lazygit Custom Commands

| Key | Context | Action |
|-----|---------|--------|
| `B` | Global | Open repository in GitHub |
| `b` | Branches | Open selected branch in GitHub |
| `b` | Files | Open selected file in GitHub |
