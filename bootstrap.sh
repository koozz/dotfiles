#!/usr/bin/env bash

printTitle() {
	printf "\n\033[1;34m%s\n" "$1"
	printf '%0.s-' $(seq 1 ${#1})
	printf "\033[0m\n"
}

(
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	cd "${SCRIPT_DIR}" || exit 1

	printTitle "Symlinking dotfiles"
	backup="$(mktemp -d)"
	git ls-files | while read -r file; do
		[[ "${file}" == "bootstrap.sh" ]] && continue
		[[ "${file}" == ".github/README.md" ]] && continue
		[[ "${file}" =~ ^Pictures/.*.svg$ ]] && continue

		directory=$(dirname "${file}")
		source="${PWD}/${file}"
		target="${HOME}/${file}"

		if [[ ! -d "${HOME}/${directory}" ]]; then
			mkdir -p "${HOME}/${directory}"
		fi
		if [[ ! -L "${target}" ]]; then
			if [[ -e "${target}" ]]; then
				echo "Moving ${target} to ${backup}"
				mkdir -p "${backup}/${directory}"
				mv -f "${target}" "${backup}/${file}"
			fi
			echo "Symlinking ${source}"
			ln -s "${source}" "${target}"
		else
			echo "Skipping ${file}"
		fi
	done

	if [[ -e /System ]]; then
		printTitle "Setting up Mac"
		BREW="/opt/homebrew/bin/brew"
		if [[ ! -x "${BREW}" ]]; then
			printTitle "Installing brew"
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi

		printTitle "Mac: Installing/updating tools (brew)"
		"$BREW" bundle --global --cleanup --force

		if [[ -x "$(command -v gh)" && ! -x "${HOME}/.local/share/gh/extensions/gh-dash/gh-dash" ]]; then
			printTitle "Mac: Installing GitHub extensions"
			gh extension install dlvhdr/gh-dash
		fi

		if [[ ! -e /opt/homebrew/bin/docker && -e /opt/homebrew/podman ]]; then
			printTitle "Mac: Symlinking tools"
			ln -sf /opt/homebrew/podman /opt/homebrew/bin/docker
		fi

		if [[ ! -f /etc/pam.d/sudo_local && -f /etc/pam.d/sudo_local.template ]]; then
			printTitle "Mac: Enable TouchID for sudo"
			sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local
		fi

		if [[ -x "$(command -v defaults)" ]]; then
			printTitle "Mac: Writing Apple defaults"
			defaults write com.apple.dock autohide -bool true
			defaults write com.apple.dock orientation -string bottom
			defaults write com.apple.dock tilesize -int 32
			defaults write com.apple.dock largesize -int 64
			killall Dock
		fi

		if [[ -x "$(command -v rsvg-convert)" ]]; then
			printTitle "Mac: Converting and setting wallpaper"
			for file in $(git ls-files); do
				if [[ "${file}" =~ ^Pictures/background.svg$ ]]; then
					if [[ ! -f "${HOME}/Pictures/background.png" ]]; then
						rsvg-convert "${file}" >"${HOME}/Pictures/background.png"
					fi
					osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${HOME}/Pictures/background.png\" as POSIX file"
				fi
			done
		fi
	fi

	if [[ ! -x "$(command -v kubectl-krew)" ]]; then
		printTitle "Installing Krew"
		(
			cd "$(mktemp -d)" &&
				OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
				ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
				KREW="krew-${OS}_${ARCH}" &&
				curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
				tar zxvf "${KREW}.tar.gz" &&
				./"${KREW}" install krew
		)
		kubectl krew install ctx
	fi

	if [[ ! -x "$(command -v rustup)" ]]; then
		printTitle "Installing Rust toolchain"
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
		source "${HOME}/.cargo/env"
	else
		printTitle "Updating Rust toolchain"
		rustup update
	fi

	printTitle "Setting up Neovim"
	for package in actionlint ast-grep bash-language-server biome deno diagnostic-languageserver fish-lsp gh-actions-language-server gopls graphql-language-service-cli helm-ls jq-lsp lua-language-server marksman mdsf regols ruff rust-analyzer shellcheck stylua superhtml trivy tsgo vale-ls yaml-language-server zls; do
		if [[ ! -d "${HOME}/.local/share/nvim/mason/packages/${package}" ]]; then
			printTitle "Installing ${package} with Mason"
			nvim --headless -c "MasonInstall ${package}" +qa
		fi
	done
)
