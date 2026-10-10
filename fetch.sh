#!/usr/bin/env bash
set -euo pipefail

username=
output=
output_file=out.md

usage() {
	cat <<EOF
usage: ${0##*/} [-h] -u USERNAME -o OUTFILE...

    -h  display this help
    -u  GitHub username 
    -o  output markdown file path
EOF
	exit 1
}

writeout() { output="$output""$1"; }

[ "$#" -lt 4 ] && usage
command -v jq >/dev/null || {
	echo "Need jq"
	exit 1
}

OPTIND=1
while getopts ":ho:u:" opt; do
	case $opt in
	u)
		username="$OPTARG"
		;;
	o)
		output_file="$OPTARG"
		;;
	*)
		usage
		;;
	esac
done

[[ "$output_file" != *.md ]] && output_file="$output_file".md

echo Generating markdown for "$username"...
count=0
# Using while read < <(command) syntax is needed otherwise updated
# count gets lost in subshell
while read -r line; do
	[[ "$line" = \#* ]] && continue
	[ -z "$line" ] && continue
	writeout "$line\n"
	count=$((count + 1))
done < <(
	# GitHub caps per_page at 100, so page through the results until an empty
	# page comes back; otherwise accounts with more than 100 repos are silently
	# truncated.
	page=1
	while :; do
		names="$(curl -fsSL --header "authorization: Bearer ${GITHUB_TOKEN:?GITHUB_TOKEN is not set}" "https://api.github.com/users/$username/repos?per_page=100&page=$page" | jq -r '.[].full_name')"
		if [ -z "$names" ]; then break; fi
		printf '%s\n' "$names"
		page=$((page + 1))
	done
)
[ $count -eq 0 ] && {
	echo "Failed to read"
	exit 1
}

echo -e "$output" >"$output_file"
echo Wrote to "$output_file"
