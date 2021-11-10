# Dotfiles

### Configurations
Note: gitconfigs are maintained separately among multiple devices
- Zsh
- Tmux
- NeoVim + plugins (with backwards compatibility to Vim)


### Clean Setup
- Symlink files to your home directory (through use of [Dotbot](https://github.com/anishathalye/dotbot)): `./install`
- Configure shell theme: `p10k configure`, then install the [recommended font](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
- Install essential shell utilities: `./install_utils`
- Configure Vim/NeoVim plugins: enter NeoVim and run `:PlugInstall`
