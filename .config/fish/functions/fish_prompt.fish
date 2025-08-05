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

	# Directory color depending on all pipestatus outputs
	if test (math max (string replace -a " " "," "$last_pipestatus")) -gt 0
		set_color --bold $fish_color_status
	else
		set_color --bold $fish_color_cwd
	end

	# Git root, used multiple times
	if test (git rev-parse --is-inside-work-tree 2>/dev/null)
		set -f git_root (basename (git rev-parse --show-toplevel 2>/dev/null))
		set -l relative (git rev-parse --show-prefix 2>/dev/null)

		printf '%s' "$git_root"
		set_color normal
		printf '%s ' (fish_git_prompt)

		if test -n "$relative"
			printf '%s ' "$relative"
		end
	else
		printf '%s ' (prompt_pwd --dir-length 0)
	end
	set_color normal
end
