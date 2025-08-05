if status is-interactive
    # Set config home
    if test -z "$XDG_CONFIG_HOME"
        set -gx XDG_CONFIG_HOME ~/.config
    end

    # Expand path (prepending to let tools take precedence)
    fish_add_path -g /opt/homebrew/bin ~/.cargo/bin ~/go/bin ~/.krew/bin ~/.config/fish/extensions ~/.local/share/nvim/mason/bin ~/.opencode/bin

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

    ulimit -n 1024

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

    # Mcfly history search (ctrl+r)
    # if command -q mcfly
    #     mcfly init fish | source
    # end

    # Setup vi cursor
    set fish_cursor_default block
    set fish_cursor_insert line blink
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    set fish_cursor_external line
    set fish_cursor_visual block

    # Tokyo Night theme
    set -l foreground c0caf5
    set -l selection 283457
    set -l comment 565f89
    set -l red f7768e
    set -l orange ff9e64
    set -l yellow e0af68
    set -l green 9ece6a
    set -l purple 9d7cd8
    set -l cyan 7dcfff
    set -l pink bb9af7

    # Syntax Highlighting Colors
    set -g fish_color_normal $foreground
    set -g fish_color_command $cyan
    set -g fish_color_keyword $pink
    set -g fish_color_quote $yellow
    set -g fish_color_redirection $foreground
    set -g fish_color_end $orange
    set -g fish_color_option $pink
    set -g fish_color_error $red
    set -g fish_color_param $purple
    set -g fish_color_comment $comment
    set -g fish_color_selection --background=$selection
    set -g fish_color_search_match --background=$selection
    set -g fish_color_operator $green
    set -g fish_color_escape $pink
    set -g fish_color_autosuggestion $comment

    # Completion Pager Colors
    set -g fish_pager_color_progress $comment
    set -g fish_pager_color_prefix $cyan
    set -g fish_pager_color_completion $foreground
    set -g fish_pager_color_description $comment
    set -g fish_pager_color_selected_background --background=$selection

    # Tokyo Night theme for fzf
    if command -q fzf
        fzf --fish | source
        set -gx FZF_DEFAULT_OPTS "--highlight-line --info=inline-right --ansi --layout=reverse --border=none --color=bg+:#283457 --color=bg:#16161e --color=border:#27a1b9 --color=fg:#c0caf5 --color=gutter:#16161e --color=header:#ff9e64 --color=hl+:#2ac3de --color=hl:#2ac3de --color=info:#545c7e --color=marker:#ff007c --color=pointer:#ff007c --color=prompt:#2ac3de --color=query:#c0caf5:regular --color=scrollbar:#27a1b9 --color=separator:#ff9e64 --color=spinner:#ff007c"
    end
end
