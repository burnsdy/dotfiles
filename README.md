# Dotfiles

### Configurations
Note: gitconfigs maintained independently
- Zsh
  - Customizable theme provided through [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- NeoVim
  - Preconfigured with 20+ useful plugins
  - Error-free backwards compatibility to Vim
- Tmux

### Installation
1. Symlink files to your home directory (through use of [Dotbot](https://github.com/anishathalye/dotbot)): `./install`
2. Install essential shell utilities for macOS/Ubuntu (not configured for Windows): `sh ./install_utils.sh`
3. Ensure powerlevel10k was installed and configure shell theme: `p10k configure`, then install the [recommended font](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k) (if it wasn't already installed during theme configuration)
4. Configure Vim/NeoVim plugins: `nvim -c :PlugInstall`
