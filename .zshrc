source /etc/zshrc

# Use vi keybindings
bindkey -v

# Double ESC to clear screen
bindkey '\e\e' clear-screen

# Keep 1000 lines of clean history in $HOME/.zsh_history:
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$HOME/.zsh_history

if [[ -d /opt/homebrew/bin ]]; then
  PATH=${PATH}:/opt/homebrew/bin
fi
export PATH

PS1='%n@%m:%1~$ '
