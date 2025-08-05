function fish_greeting
	if not set -q ASCIINEMA_REC
		echo Session started at (set_color yellow; date +%T; set_color normal)
	end
end
