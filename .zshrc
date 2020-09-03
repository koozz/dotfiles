# vim:ft=zsh ts=2 sw=2 sts=2 fenc=utf-8

# Use vi keybindings
bindkey -v

# Double ESC to clear screen
bindkey '\e\e' clear-screen

# Keep 1000 lines of history within the shell and save it to $HOME/.zsh_history:
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$HOME/.zsh_history

# Use modern completion system
if [[ -d "$HOME/.config/zsh/completions" ]]; then
	fpath+=$HOME/.config/zsh/completions
fi
autoload -Uz compinit && compinit

export LSCOLORS="ExGxfxcxbxegehbhbgacad"

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Aliases
alias ls='ls -F --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Functions
[[ ! -f "$HOME/.zfunc.zsh" ]] || source "$HOME/.zfunc.zsh"

# Expand path
declare -a PATH_EXT
PATH_EXT=(
	$HOME/.bin
	$HOME/.cargo/bin
	$HOME/.krew/bin
	$HOME/go/bin
	$HOME/.local/bin
	/usr/share/bcc/tools
)
for ext in "${PATH_EXT[@]}"; do
	if [[ -d "$ext" ]]; then
		PATH="$PATH:$ext"
	fi
done
export PATH

# Expand cdpath
if [[ -d "$HOME/projects" ]]; then
	CDPATH="."
	for dir in "$HOME"/projects/*; do
		CDPATH="$CDPATH:$dir"
	done
	export CDPATH
fi

# Hook direnv (if installed)
if [[ -x "$(command -v direnv)" ]]; then
	eval "$(direnv hook zsh)"
fi

# Vim over vi if installed
if [[ -x "$(command -v vim)" ]]; then
	KUBE_EDITOR=vim
	EDITOR=vim
	export KUBE_EDITOR
	export EDITOR
fi

# Fzf config
if [[ -x "$(command -v rg)" ]]; then
	FZF_DEFAULT_COMMAND='rg --files --hidden --glob="!venv/*" --glob="!go/pkg/*" --glob="!.azure/*"'
elif [[ -x "$(command -v fd)" ]]; then
	FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude venv --exclude go/pkg'
fi
export FZF_DEFAULT_COMMAND

# Zsh customization
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
ZSH_AUTOSUGGEST_USE_ASYNC=1
declare -a ZSH_EXTENSIONS
ZSH_EXTENSIONS=(
	$HOME/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme
	$HOME/.config/zsh/zsh-abbr/zsh-abbr.zsh
	$HOME/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
	$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
)
for extension in "${ZSH_EXTENSIONS[@]}"; do
	if [[ -r "$extension" ]]; then
		source "$extension"
	fi
done
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# If c is installed, make c files script-executable from within zsh
if [[ -x "$(command -v c)" ]]; then
	alias -s c='c'
	alias -s cc='c'
	alias -s cpp='c'
fi

# GPG agent, prefer version 2, fire up, load settings and setup
if [[ -x "$(command -v gpg2)" ]]; then
	alias gpg='gpg2'
fi
GPG_TTY=$(tty)
export GPG_TTY

# If .xinitrc failed to start the gpg-agent
if ! pgrep gpg-agent > /dev/null 2>&1; then
	eval $(gpg-agent --daemon --enable-ssh-support --sh)
else
	SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
	export SSH_AUTH_SOCK
fi
gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1
