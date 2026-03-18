# Dotfiles

My development environment configuration using [Dotbot](https://github.com/anishathalye/dotbot).

## Contents

- **nvim** - Neovim configuration with Lazy.nvim, Telescope, LSP, and Elixir tooling
- **tmux** - Tmux configuration with vim-tmux-navigator integration

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

This creates symlinks for:
- `~/.config/nvim/init.lua`
- `~/.tmux.conf`
