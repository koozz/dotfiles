export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# gpgconf --launch gpg-agent
eval $(gpg-agent --daemon --enable-ssh-support --sh)
exec gnome-session
