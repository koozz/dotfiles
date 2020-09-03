# Dotfiles

These are my dotfiles.

Tips and tricks are always welcome.

## TLDR

```bash
git clone https://github.com/koozz/dotfiles.git $HOME/dotfiles
$HOME/dotfiles/install.sh
```

## Fancy deprecated setup

At first I started with the bare repository setup, i.e.:

```bash
git init --bare $HOME/.dotfiles
echo ".dotfiles/" >> .gitignore
echo ".bash_history" >> .gitignore
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
#dotfiles add [files]
#dotfiles commit -m "Add dotfiles."
#dotfiles push
```

And usage like:

```bash
git clone --bare https://github.com/koozz/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout # Delete files blocking your checkout
```

But this didn't play well with GitHub Codespaces.
## Latest setup

To make the dotfiles repository work with GitHub Codespaces, it will be
automatically initialized with either `bootstrap.sh` or `install.sh`.

This made me revert it back to a simple [install.sh](install.sh) that:

* Lists the repository's (hidden) directories and creates these in your `$HOME`.
* Lists the repository's (hidden) files and copies them over to your `$HOME`.
* Loops over some Zsh dependencies and clones them or updates them.
