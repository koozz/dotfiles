function spotify
    if command -v ncspot &>/dev/null
		tmux rename-window Spotify
        caffeinate -i ncspot
    else
        echo "ncspot not found."
        return 1
    end
end
