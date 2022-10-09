# Plugins
source ~/.config/zsh/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-history-substring-search.zsh
export EDITOR=vim
export PATH="${PATH}:${HOME}/.local/bin/"
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt autocd
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
autoload -Uz colors && colors
compinit
source ~/.config/zsh/theme.zsh
setopt correct
# End of lines added by compinstall
alias fds='du -sh'
alias ls='ls --color=auto'
#PS1='[%n@%m %1~]%# '
autoload -U promptinit; promptinit

