#!/usr/bin/env bash
# vim:ft=bash ts=2 sw=2 sts=2 fenc=utf-8
set -euo pipefail

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
(
  # Have sub-shell in this folder
	cd "$DOTFILES_DIR"
	branch="$(git rev-parse --abbrev-ref HEAD)"

	# Create all hidden directories
	for dir in $(git ls-tree -d -r --name-only "$branch" | grep "^\."); do
		mkdir -p "$HOME/$dir"
	done

	# Copy over all hidden files
	for file in $(git ls-tree -r --name-only "$branch" | grep "^\."); do
		cp "$file" "$HOME/$file"
	done

	# If we have a Pictures dir, copy those too
	if [[ -d "$HOME/Pictures" ]]; then
		cp Pictures/* "$HOME/Pictures/"
	fi

	# Prep / update zsh dependencies
	declare -a ZSH_EXTENSIONS
	ZSH_EXTENSIONS=(
    https://github.com/romkatv/powerlevel10k.git
    https://github.com/olets/zsh-abbr.git
    https://github.com/zsh-users/zsh-history-substring-search.git
    https://github.com/zsh-users/zsh-syntax-highlighting.git
    https://github.com/zsh-users/zsh-autosuggestions.git
  )
  for repo in "${ZSH_EXTENSIONS[@]}"; do
    repogit=$(basename "$repo")
    plugindir="$HOME/.config/zsh/${repogit%.git}"
    if [[ ! -d "$plugindir" ]]; then
      git clone --depth=1 "$repo" "$plugindir"
    else
      echo -n "$repogit: "
      (cd "$plugindir" && git pull --ff-only)
    fi
  done
)
