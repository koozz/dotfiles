function gh --wraps gh
	if test $argv[1] = repo; and test $argv[2] = clone
		# Clone into $HOME/git/<owner>/<repo> and change directory into it
		set -l base "$HOME/git"

		# Owner
		set -l owner (dirname $argv[3])
		if not test -d $base/$owner
			mkdir -p $base/$owner
		end

		# Repository
		set -l repo (basename $argv[3])
		if not test -d $base/$owner/$repo
			cd $base/$owner
			and command gh repo clone $owner/$repo
			and cd $base/$owner/$repo
		else
			cd $base/$owner/$repo
			and command gh repo sync
		end
	else
		command gh $argv
	end
end
