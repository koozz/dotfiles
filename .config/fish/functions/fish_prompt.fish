function fish_prompt --description 'Write out the prompt'
	set -l last_pipestatus $pipestatus
	set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

	if not set -q __fish_git_prompt_show_informative_status
		set -g __fish_git_prompt_show_informative_status 1
	end
	if not set -q __fish_git_prompt_hide_untrackedfiles
		set -g __fish_git_prompt_hide_untrackedfiles 1
	end
	if not set -q __fish_git_prompt_color_branch
		set -g __fish_git_prompt_color_branch magenta --bold
	end
	if not set -q __fish_git_prompt_showupstream
		set -g __fish_git_prompt_showupstream informative
	end
	if not set -q __fish_git_prompt_color_dirtystate
		set -g __fish_git_prompt_color_dirtystate blue
	end
	if not set -q __fish_git_prompt_color_stagedstate
		set -g __fish_git_prompt_color_stagedstate yellow
	end
	if not set -q __fish_git_prompt_color_invalidstate
		set -g __fish_git_prompt_color_invalidstate red
	end
	if not set -q __fish_git_prompt_color_untrackedfiles
		set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
	end
	if not set -q __fish_git_prompt_color_cleanstate
		set -g __fish_git_prompt_color_cleanstate green --bold
	end

	# Git root, used multiple times
	if test (git rev-parse --is-inside-work-tree 2>/dev/null)
		set -f git_root (basename (git rev-parse --show-toplevel 2>/dev/null))
	end

	# Kubernetes context
	# if command -q kubectl
	# 	set_color --bold cyan
	# 	kubectl config view --minify -o jsonpath='@{.contexts[0].context.cluster}:{.contexts[0].context.namespace} ' 2>/dev/null
	# 	set_color normal
	# end

	# Pulumi stack
	# if command -q pulumi
	# 	if test -n "$git_root"
	# 		set_color --bold purple
	# 		echo -n (find ~/.pulumi/workspaces -type f -name "$git_root-*" -exec jq -jr '(.stack + " ")' {} \; 2>/dev/null)
	# 		set_color normal
	# 	end
	# end

	# Directory color depending on all pipestatus outputs
	if test (math max (string replace -a " " "," "$last_pipestatus")) -gt 0
		set_color --bold $fish_color_status
	else
		set_color --bold $fish_color_cwd
	end

	# Directory relative from the git root or pwd
	if test -n "$git_root"
		set -l relative (git rev-parse --show-prefix 2>/dev/null)
		echo -n "$git_root/$relative"
	else
		echo -n (prompt_pwd --dir-length 0)
	end
	set_color normal

	# Git status
	printf '%s ' (fish_git_prompt)
	set_color normal
end
