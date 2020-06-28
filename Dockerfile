FROM clojure:openjdk-11-tools-deps-1.10.1.536-slim-buster

ARG HOST_UID=1001
ARG HOST_GID=1001

RUN groupadd -g $HOST_GID app-user &&\
    useradd -u $HOST_UID -g $HOST_GID -m app-user &&\
    mkdir /usr/local/src/app && chown $HOST_UID:$HOST_GID /usr/local/src/app

COPY rlwrap-workaround /usr/local/bin

USER app-user
WORKDIR /usr/local/src/app

ENTRYPOINT ["/usr/local/bin/rlwrap-workaround"]
