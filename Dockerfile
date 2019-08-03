FROM alpine:3.10.1

RUN apk --no-cache add openssh-client git bash

RUN wget https://raw.githubusercontent.com/fsaintjacques/semver-tool/2.1.0/src/semver -P /usr/local/bin && chmod +x /usr/local/bin/semver

RUN git config --global user.email "git-semver-store@henrik.ninja" &&\
    git config --global user.name "Git Semver Store"

RUN mkdir /app && mkdir -p ~/.ssh
WORKDIR /app

COPY ./update.sh ./update.sh

ENTRYPOINT [ "/app/update.sh" ]