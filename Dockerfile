FROM alpine:3.14.0@sha256:234cb88d3020898631af0ccbbcca9a66ae7306ecd30c9720690858c1b007d2a0

RUN apk --no-cache add openssh-client git bash

RUN wget https://raw.githubusercontent.com/fsaintjacques/semver-tool/2.1.0/src/semver -P /usr/local/bin && chmod +x /usr/local/bin/semver

RUN git config --global user.email "git-semver-store@henrik.ninja" &&\
    git config --global user.name "Git Semver Store"

RUN mkdir /app && mkdir -p ~/.ssh
WORKDIR /app

COPY ./increment.sh /usr/local/bin/increment
COPY ./check.sh /usr/local/bin/check