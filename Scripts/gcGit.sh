rm -rf .git/refs/original/*
git reflog expire --all --expire-unreachable=0
git repack -A -d
git prune