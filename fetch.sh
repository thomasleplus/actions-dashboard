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
command -v jq > /dev/null || { echo "Need jq"; exit 1; }

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

tmpd="$(mktemp -d -t dashboardXXXX)"

echo Generating markdown for "$username"...
count=0
while read -r line; do
    [[ "$line" = \#* ]] && continue
    [ -z "$line" ] && continue
    writeout "$line\n"
    count=$((count+1))
done < <(curl -sL --header "authorization: Bearer ${GITHUB_TOKEN}" "https://api.github.com/users/$username/repos?per_page=100"  | jq -r '.[].full_name' )
[ $count -eq 0 ] && { echo "Failed to read"; exit 1; }

echo -e "$output" > "$output_file"
echo Wrote to "$output_file"
rm -rf "$tmpd"
