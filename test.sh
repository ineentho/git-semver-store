#!/bin/sh

version_before=$(docker run --rm -e SSH_PRIVATE_KEY ineentho/git-semver-store check ssh://git@gitlab.henrik.ninja:10022/ineentho/versions-test.git test.txt)
version=$(docker run --rm -e SSH_PRIVATE_KEY ineentho/git-semver-store increment ssh://git@gitlab.henrik.ninja:10022/ineentho/versions-test.git test.txt patch "$CI_COMMIT_SHA")
version_after=$(docker run --rm -e SSH_PRIVATE_KEY ineentho/git-semver-store check ssh://git@gitlab.henrik.ninja:10022/ineentho/versions-test.git test.txt)

major=$(echo "$version_before" | cut -d. -f1)
minor=$(echo "$version_before" | cut -d. -f2)
patch=$(echo "$version_before" | cut -d. -f3)

patch=$((patch+1))

expected_version="$major.$minor.$patch"

if [ "$version" != "$expected_version" ]; then
    echo "version $version != expected_version $expected_version"
    exit 1
fi

if [ "$version_after" != "$expected_version" ]; then
    echo "version_after $version_after != expected_version $expected_version"
    exit 1
fi