#!/bin/bash
#

# If anything fails, exit with 1
set -e

# A git hook script to find and fix trailing whitespace and tabs
# in your commits. Bypass it with the --no-verify option
# to git-commit
#
# usage: make a soft link to this file, e.g., ln -s ~/config/pre-commit.git.sh ~/some_project/.git/hooks/pre-commit

# change IFS to ignore filename's space in |for|
IFS="
"
# autoreplace tabs with 4 spaces
for line in `git diff --check --cached | sed '/^[+-]/d'` ; do
  # get file name
  file="`echo $line | sed -r 's/:[0-9]+: .*//'`"
  # display tips
  echo -e "auto remove trailing whitespace in \033[31m$file\033[0m!"
  # since $file in working directory isn't always equal to $file in index, so we backup it
  mv -f "$file" "${file}.save"
  # discard changes in working directory
  git checkout -- "$file"
  # replace tabs
  sed 's/\t/    /' "$file" > "${file}.bak"
  mv -f "${file}.bak" "$file"
  git add "$file"
  # restore the $file
  sed 's/\t/    /' "${file}.save" > "$file"
  rm "${file}.save"
done

# autoremove trailing whitespace
for line in `git diff --check --cached | sed '/^[+-]/d'` ; do
  # get file name
  file="`echo $line | sed -r 's/:[0-9]+: .*//'`"
  # display tips
  echo -e "auto replacing tabs in \033[31m$file\033[0m!"
  # since $file in working directory isn't always equal to $file in index, so we backup it
  mv -f "$file" "${file}.save"
  # discard changes in working directory
  git checkout -- "$file"
  # remove trailing whitespace
  sed 's/[[:space:]]*$//' "$file" > "${file}.bak"
  mv -f "${file}.bak" "$file"
  git add "$file"
  # restore the $file
  sed 's/[[:space:]]*$//' "${file}.save" > "$file"
  rm "${file}.save"
done

if [ "x`git status -s | grep '^[A|D|M]'`" = "x" ]; then
  # empty commit
  echo
  echo -e "\033[31mNO CHANGES ADDED, ABORT COMMIT!\033[0m"
  exit 1
fi

# Now we can commit
exit