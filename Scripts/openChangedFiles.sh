#! /bin/bash

 let changes=0

# Read through changed file statuses and open for editing those that have unmerged changes (and conflicts)
 while read status filename; do
    if [[ $status == *"U"* || $status == "AA" || $status == "DD" ]]; then
        let changes=1
        (sublime "$filename" &)
    fi
 done < <(git status --porcelain)

# If no changes are found, notify user
 if (( ! changes )); then
    echo "No unmerged changes."
 fi
