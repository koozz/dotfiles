# Get homebrew apps on PATH
if [[ -d /opt/homebrew/bin ]]; then
  PATH="${PATH}:/opt/homebrew/bin"
fi
export PATH

# Simple prompt
PS1='\u@\H:\w\$ '
