function ls --wraps ls
	if command -q eza
		command eza $argv
	else
		command ls $argv
	end
end
