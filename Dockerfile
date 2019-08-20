FROM alpine:3.10.2@sha256:72c42ed48c3a2db31b7dafe17d275b634664a708d901ec9fd57b1529280f01fb

RUN apk --no-cache add openssh-client git bash

RUN wget https://raw.githubusercontent.com/fsaintjacques/semver-tool/2.1.0/src/semver -P /usr/local/bin && chmod +x /usr/local/bin/semver

RUN git config --global user.email "git-semver-store@henrik.ninja" &&\
    git config --global user.name "Git Semver Store"

RUN mkdir /app && mkdir -p ~/.ssh
WORKDIR /app

COPY ./increment.sh /usr/local/bin/increment
COPY ./check.sh /usr/local/bin/check