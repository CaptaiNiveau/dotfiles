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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# enables comments in command prompt, like 'ls #command to list files'
setopt interactivecomments

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

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -v '^?' backward-delete-char

# Fix home, end and del keys
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
#bindkey -s '^o' 'lfcd\n'

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
bindkey -s '^o' 'yy\n'

# TheFuck
eval $(thefuck --alias)

# use fd for default fzf command
export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# add ~/.local/bin to PATH
export PATH=$PATH:$HOME/.local/bin

# add ~/.local/custom to PATH
export PATH=$PATH:$HOME/.local/custom
export PATH=$PATH:$HOME/.local/custom/ueberzug

# add ~/synch/scripts to PATH
export PATH=$PATH:$HOME/synch/scripts

# add jetbrains ~/.local/share/JetBrains/Toolbox/scripts to PATH
export PATH=$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts

# add dotnet tools to PATH
export PATH=$PATH:$HOME/.dotnet/tools

# add doom emacs to PATH
export PATH=$PATH:$HOME/.config/emacs/bin

# add go binaries to PATH
export PATH=$PATH:/home/captain/go/bin

# make lvim default
export EDITOR=nvim

# force less as pager
export PAGER=/bin/less

# zig zvm stuff
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/autojump/autojump.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh
source /usr/share/zsh/plugins/forgit/forgit.plugin.zsh
source /usr/share/zsh/site-functions/_git-forgit
source /usr/share/zsh/plugins/zsh-fzf-plugin/fzf.plugin.zsh
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh
#source /usr/share/fzf-tab-completion/zsh/fzf-zsh-completion.sh

eval "$(atuin init --disable-ctrl-r zsh)"
bindkey -M vicmd '^[[A' up-line-or-history

# ALT-C: cd into the selected directory
# CTRL-T: Place the selected file path in the command line
# CTRL-R: Place the selected command from history in the command line
# CTRL-P: Place the selected process ID in the command line
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval $(thefuck --alias)
