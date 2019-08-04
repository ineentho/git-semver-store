# Git Semver Store

Git Semver Store is a tool that allows you to store version numbers outside of your code repository. Inspired by concourses [semver-resource](https://github.com/concourse/semver-resource), but stores the complete history and is CI system agnostic.

The intended usage is to run something like

```
version=$(docker run --rm -e SSH_PRIVATE_KEY ineentho/git-semver-store increment ssh://git@gitlab.henrik.ninja:10022/ineentho/versions.git git-semver-store.txt patch "$CI_COMMIT_SHA")
```
in CI and use the resulting version to tag a docker image / npm package / anything else.

## Reference

The git-semver-store docker image contains two different commands: `check` for getting the current version and `increment` to increment the semver.

### Environment Variables

To be able to pull the git repository, the SSH_PRIVATE_KEY variable must be set to a full ssh private key that has access to pull and push to the versions repo. Required for both check and increment.

### check

Get the current stored version

```
docker run --rm ineentho/git-semver-store check
Usage: check repo file

repo: The full ssh url to the version repo, example: git@github.com:my/version-repo.git
file: The path to the version file, example: project-name.txt
```

### increment

Increment the semver by either major / minor or patch. If the file doesn't already exist, it is initialized to version 0.0.0.

```
docker run --rm ineentho/git-semver-store increment
Usage: increment repo file increment hash

repo: The full ssh url to the version repo, example: git@github.com:my/version-repo.git
file: The path to the version file, example: project-name.txt
increment: Which part of the semver number to increment. Valid options are major, minor and patch.
hash: Git hash to store as a reference
```

## Example Usage

### Gitlab CI

There are multiple ways to use this image. Either you can set the image to `ineentho/git-semver-store`, or if you already are using docker in docker it may be easier to use that. An example using dind to version a docker image:

```
push:
  stage: push
  image: docker:19.03.1
  only:
    refs:
      - master
  before_script:
    - docker login -u $DOCKER_USERNAME -p "$DOCKER_PASSWORD"
  script:
    - docker load -i git-semver-store.tar
    - version=$(docker run --rm -e SSH_PRIVATE_KEY ineentho/git-semver-store increment ssh://git@gitlab.henrik.ninja:10022/ineentho/versions.git git-semver-store.txt patch "$CI_COMMIT_SHA")

    - image_version="ineentho/git-semver-store:$version"
    - docker tag ineentho/git-semver-store $image_version
    - docker push $image_version
```

The resulting versions file `git-semver-store.txt` will look something like this:

```
0.0.1	e52f7f9e713ee05e73a09c3e98020a2789139e73
0.0.2	c31d1a47621e678618a9900e0ec46eb3aa6ce91b
0.0.3	e14728e269903c0014eb784a41006da92bea5bc4
```

You can see the versions repo this project uses here: [ineentho/versions](https://gitlab.henrik.ninja/ineentho/versions/blob/master/git-semver-store.txt)