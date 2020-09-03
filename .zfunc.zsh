#!/usr/bin/env bash
# vim:ft=zsh ts=2 sw=2 sts=2 fenc=utf-8

az-sub () {
	# Switch subscription interactively
	az account list 1>/dev/null 2>&1 || az login
	az account set --subscription "$(az account list -o tsv --query "[].name" | fzf)"
}
ff () {
	# Run with: ff <text-search>
	# Matches are only shown partially
	rg --files-with-matches --no-messages "$*" . |
	fzf --preview "rg --ignore-case --pretty --context 10 \"$*\" {}"
}
fff () {
	# Same as 'ff' but shows full file contents
	rg --files-with-matches --no-messages "$*" . |
	fzf --preview "bat --style=numbers --color=always {}"
}
git-all () {
	if [[ -z "$1" ]]; then
		set -- status
	fi
	for repo in $(find . -type d -name .git | sed -e 's|./||' -e 's|/.git||')
	do
		echo "▼ $repo"
		git -C "$repo" $*
		echo
	done
}
git-mr () {
	# Lazy...
	BRANCH=$1; shift
	MESSAGE="$*"
	git checkout -b $BRANCH --track
	git commit -am "$MESSAGE"
	git push --set-upstream origin
}
kns () {
	# Prerequisites: kubectl kubectl-krew kubectl-ctx and fzf
	kubectl ctx
	node="$(kubectl get nodes -o name | sed -e 's|^node/||g' | fzf)"
	if [[ ! -z "$node" ]]; then
		kubectl node-shell "$node" -- sh
	fi
}
rancher-to-kubeconfig () {
	rm -f ~/.kube/kube-config-*.yml
	echo -n '.'
	for env in on-prem dta prd; do
		rancher server switch $env 2>/dev/null 1>&2
		rancher clusters ls --format '{{.Cluster.ID}} {{.Cluster.Name}}' | while read id name; do
			echo -n '.'
			rancher clusters kubeconfig $id $name > ~/.kube/kube-config-${id}.yml
		done
	done
	KUBECONFIG="`echo $( ls -1 ~/.kube/kube-config-*.yml ) | sed 's/ /:/g'`" kubectl config view --flatten > ~/.kube/config
	echo ' done'
}
