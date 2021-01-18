#! /usr/bin/env bash

OPTIONS=()
SKIPPED=()
TEMP_BRANCHES=()
BRANCHES=()

while [[ $# -gt 0 ]]
do
key="$1"

	case $key in
	    -f|--filter)
	    FILTER="$2"
	    shift # past argument
	    shift # past value
	esac
done

eval "$(git for-each-ref --shell --format='TEMP_BRANCHES+=(%(refname))' refs/heads/)"

i=0
max_width=0
for branch in "${TEMP_BRANCHES[@]}"; do
	if [[ -z $FILTER || $branch == *$FILTER* ]]; 
		then
			if [[ $i -lt 1 ]]; then
				echo "Choose a Branch:"
			fi

			OPTIONS+=($i)
			i="$((i+1))"
			branch=${branch:11}
			BRANCHES+=($branch)
			OPTIONS+=($branch)
			echo $i : $branch
			if [ "${#branch}" -gt "$max_width" ]; then
				max_width="${#branch}"
			fi
	fi
done

read -p "Choice: " CHOICE

if [[ -z $CHOICE ]];
	then
		exit 1
fi

re='^[0-9]+$'
if ! [[ $CHOICE =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi

if [[ $CHOICE -gt "$((i))" || $CHOICE -lt 1 ]]; then
	echo "Invalid Choice: $CHOICE"
	exit 1
fi

echo ${BRANCHES[$((CHOICE-1))]}
git co ${BRANCHES[$((CHOICE-1))]}
