FROM alpine:3.10.3@sha256:e4355b66995c96b4b468159fc5c7e3540fcef961189ca13fee877798649f531a

RUN apk --no-cache add openssh-client git bash

RUN wget https://raw.githubusercontent.com/fsaintjacques/semver-tool/2.1.0/src/semver -P /usr/local/bin && chmod +x /usr/local/bin/semver

RUN git config --global user.email "git-semver-store@henrik.ninja" &&\
    git config --global user.name "Git Semver Store"

RUN mkdir /app && mkdir -p ~/.ssh
WORKDIR /app

COPY ./increment.sh /usr/local/bin/increment
COPY ./check.sh /usr/local/bin/check