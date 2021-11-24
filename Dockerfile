FROM alpine:3.15.0@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300

RUN apk --no-cache add openssh-client git bash

RUN wget https://raw.githubusercontent.com/fsaintjacques/semver-tool/2.1.0/src/semver -P /usr/local/bin && chmod +x /usr/local/bin/semver

RUN git config --global user.email "git-semver-store@henrik.ninja" &&\
    git config --global user.name "Git Semver Store"

RUN mkdir /app && mkdir -p ~/.ssh
WORKDIR /app

COPY ./increment.sh /usr/local/bin/increment
COPY ./check.sh /usr/local/bin/check