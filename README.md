# Dotfiles

### Configurations
Note: gitconfigs are maintained separately among multiple devices
- Zsh
- Tmux
- NeoVim + plugins (with backwards compatibility to Vim)


### Installation
1. Symlink files to your home directory (through use of [Dotbot](https://github.com/anishathalye/dotbot)): `./install`
2. Configure shell theme: `p10k configure`, then install the [recommended font](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
3. Install essential shell utilities: `./install_utils`
4. Configure Vim/NeoVim plugins: `nvim -c :PlugInstall`
