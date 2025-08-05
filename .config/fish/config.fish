if status is-interactive
    # Set config home
    if test -z "$XDG_CONFIG_HOME"
        set -gx XDG_CONFIG_HOME ~/.config
    end

    # Expand path (prepending to let tools take precedence)
    fish_add_path -g /opt/homebrew/bin ~/.cargo/bin ~/go/bin ~/.krew/bin ~/.config/fish/extensions ~/.local/bin ~/.local/share/nvim/mason/bin ~/.opencode/bin

    # Abbreviations
    abbr -a ... "cd (git rev-parse --show-toplevel)"
    abbr -a aap "kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode | pbcopy"
    abbr -a bb brew bundle --global --cleanup --force
    abbr -a gca git commit --amend --no-edit
    abbr -a gds git diff --staged
    abbr -a gp git pull
    abbr -a gpf git push --force-with-lease
    abbr -a gpo git push -u origin
    abbr -a gpr gh pr create --fill
    abbr -a gs git status
    abbr -a k kubectl
    abbr -a kk kubectl kaas
    abbr -a kkn kubectl kaas nonprd
    abbr -a kkp kubectl kaas prd
    abbr -a kkm kubectl config set-context --current --namespace kube-system
    abbr -a kc kubectl config unset current-context
    abbr -a klc "kubectl get pods -o json | jq -r '.items.[].spec | (.containers,.initContainers) | try .[].image'"
    abbr -a kpf "kubectl patch -p '{\"metadata\":{\"finalizers\":null}}' --type=merge ns"
    abbr -a kx kubectl ctx
    abbr -a kn kubectl ns
    abbr netshoot "kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot"
    abbr netshoot-node "kubectl run tmp-shell --rm -i --tty --overrides='{\"spec\": {\"hostNetwork\": true}}' --image nicolaka/netshoot"
    if command -q nvim
        abbr -a e nvim
        abbr -a n nvim
        abbr -a neo nvim
        abbr -a vi nvim
        abbr -a vim nvim
    end
    abbr -a ppd "TF_LOG=TRACE pulumi preview --logtostderr --logflow -v=10 2> out.txt"
    abbr -a zw zig build --watch -fincremental --prominent-compile-errors

    # # Quick path navigation
    set --local --path cdpath .
    for dir in ~/git/*
        set --path --append cdpath $dir
    end
    set --export --path CDPATH $cdpath

    # Ripgrep settings
    if command -q rg; and test -f ~/.ripgreprc
        set -gx RIPGREP_CONFIG_PATH ~/.config/ripgrep/config
    end

    # Set editor
    set --export EDITOR (command -v nvim vim vi | head -1)

    ulimit -n 10240

    # Setup ssh
    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c) 1>/dev/null
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    end

    # Setup GitHub
    if command -q gh
        set -gx GITHUB_TOKEN (gh auth token)
    end

    # Hook direnv
    if command -q direnv
        direnv hook fish | source
    end

    # Setup vi cursor
    set fish_cursor_default block
    set fish_cursor_insert line blink
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    set fish_cursor_external line
    set fish_cursor_visual block

	# Catppucin Mocha theme
	set -g fish_color_normal cdd6f4
	set -g fish_color_command 89b4fa
	set -g fish_color_param f2cdcd
	set -g fish_color_keyword f38ba8
	set -g fish_color_quote a6e3a1
	set -g fish_color_redirection f5c2e7
	set -g fish_color_end fab387
	set -g fish_color_comment 7f849c
	set -g fish_color_error f38ba8
	set -g fish_color_gray 6c7086
	set -g fish_color_selection --background=313244
	set -g fish_color_search_match --background=313244
	set -g fish_color_option a6e3a1
	set -g fish_color_operator f5c2e7
	set -g fish_color_escape eba0ac
	set -g fish_color_autosuggestion 6c7086
	set -g fish_color_cancel f38ba8
	set -g fish_color_cwd f9e2af
	set -g fish_color_user 94e2d5
	set -g fish_color_host 89b4fa
	set -g fish_color_host_remote a6e3a1
	set -g fish_color_status f38ba8
	set -g fish_pager_color_progress 6c7086
	set -g fish_pager_color_prefix f5c2e7
	set -g fish_pager_color_completion cdd6f4
	set -g fish_pager_color_description 6c7086

    # Catppucin Mocha theme for fzf
    if command -q fzf
        fzf --fish | source
		set -gx FZF_DEFAULT_OPTS "--highlight-line --info=inline-right --ansi --layout=reverse --border=none --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 --color=selected-bg:#45475A --color=border:#6C7086,label:#CDD6F4"
    end
end
