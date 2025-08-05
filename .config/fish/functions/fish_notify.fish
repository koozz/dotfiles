function fish_notify --on-event fish_postexec
	set -q __notify_cmd_duration; or set -g __notify_cmd_duration 5000

	set -l exit_status $status
	set -q cmd_duration; or set -l cmd_duration $CMD_DURATION
	if test $cmd_duration -gt $__notify_cmd_duration
		set -l title "$argv[1] finished"
		if test $exit_status -ne 0
			printf "\e]777;notify;%s;Failed\e\\" "$argv[1]"
		else
			printf "\e]777;notify;%s;Success\e\\" "$argv[1]"
		end

		# Pushover notification too
		if test -f $HOME/.config/fish/functions/pushover.fish
			pushover "Finished $argv[1]"
		end
	end
end
