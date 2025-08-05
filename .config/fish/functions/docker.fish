function docker --wraps docker
	# Ensure colima
	if not command -q colima
		echo "# Installing colima first"
		brew install colima
		colima completion fish >~/.config/fish/completions/colima.fish
		# Permanent install docker socket
		command colima start --runtime docker 2>/dev/null
		sudo ln -sf ~/.colima/default/docker.sock /var/run/docker.sock
	end

	# Use docker
	if not command -q docker
		brew install docker
	end

	# On-the-fly docker socket
	# set --global DOCKER_HOST "unix://~/.colima/default/docker.sock"

	command colima start --runtime docker 2>/dev/null
	command docker $argv
end
