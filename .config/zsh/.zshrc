# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
### zstyle :compinstall filename '/home/captain/.zshrc'

### autoload -Uz compinit
### compinit
# End of lines added by compinstall
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ${ZDOTDIR:-~}/.p10k.zsh ]] || source ${ZDOTDIR:-~}/.p10k.zsh

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Load everything useful
export XDG_CONFIG_HOME=$HOME/.config
[ -f "$XDG_CONFIG_HOME/zsh/zshaliasrc" ] && source "$XDG_CONFIG_HOME/zsh/zshaliasrc"
[ -f "$XDG_CONFIG_HOME/zsh/zshcompletionrc" ] && source "$XDG_CONFIG_HOME/zsh/zshcompletionrc"
[ -f "$XDG_CONFIG_HOME/zsh/zshexportrc" ] && source "$XDG_CONFIG_HOME/zsh/zshexportrc"
[ -f "$XDG_CONFIG_HOME/zsh/zshfixrc" ] && source "$XDG_CONFIG_HOME/zsh/zshfixrc"
[ -f "$XDG_CONFIG_HOME/zsh/zshvimoderc" ] && source "$XDG_CONFIG_HOME/zsh/zshvimoderc"
[ -f "$XDG_CONFIG_HOME/zsh/zshoptrc" ] && source "$XDG_CONFIG_HOME/zsh/zshoptrc"
[ -f "$XDG_CONFIG_HOME/zsh/zshshortcutrc" ] && source "$XDG_CONFIG_HOME/zsh/zshshortcutrc"
[ -f "$XDG_CONFIG_HOME/zsh/zshpluginsrc" ] && source "$XDG_CONFIG_HOME/zsh/zshpluginsrc"
