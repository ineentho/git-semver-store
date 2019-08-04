#!/bin/sh

repo=$1
file=$2
increment=$3
hash=$4

if [ ! "$repo" ] || [ ! "$file" ] || [ ! "$increment" ] || [ ! "$hash" ]; then
    echo Usage: git-semver-store repo file increment
    echo
    echo repo: The full ssh url to the version repo, example: git@github.com:my/version-repo.git
    echo file: The path to the version file, example: project-name.txt
    echo increment: Which part of the semver number to increment. Valid options are major, minor and patch.
    echo hash: Git hash to store as a reference

    exit 1
fi

echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# We have no way of checking the host key automatically
echo "Host *" > ~/.ssh/config
echo " StrictHostKeyChecking no" >> ~/.ssh/config

git clone "$repo" repo 1>&2 || exit 1
cd repo || exit 1

if [ ! -f "$file" ]; then
    touch "$file"
fi

last_version_line=$(tail -1 "$file")

version=$(echo "$last_version_line" | cut -f1)

if [ ! "$version" ]; then
    version="0.0.0"
fi

new_version=$(semver bump "$increment" "$version")

printf "%s\t%s\n" "$new_version" "$hash" >> "$file"

git add "$file"
git commit -m "Incremented $increment version of $file to $new_version" 1>&2

git push

printf "%s" "$new_version"