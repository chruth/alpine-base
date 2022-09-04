FROM alpine:3.16

ARG S6_VERSION="3.1.2.1"
ARG ARCH

ENV \
  APP_DIR="/app" \
  CONFIG_DIR="/config" \
  PGID="1000" \
  PUID="1000" \
  S6_BEHAVIOUR_IF_STAGE2_FAILS="2" \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0" \
  TZ="Europe/Berlin"

# install packages
RUN apk add --update --no-cache \
    bash \
    ca-certificates \
    coreutils \
    curl \
    shadow \
    tzdata && \
    # create app directory
    mkdir "${APP_DIR}" && \
    # s6 overlay download
    curl -o /tmp/s6overlay-noarch.tar.xz -sL \
    "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz" && \
    tar -xJf /tmp/s6overlay-noarch.tar.xz -C / && \
    curl -o /tmp/s6overlay-${ARCH}.tar.xz -sL \
    "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${ARCH}.tar.xz" && \
    tar -xJf /tmp/s6overlay-${ARCH}.tar.xz -C / && \
    # cleanup
    apk del curl && \
    rm -rf /tmp/*

# create user
RUN \
  useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false yaapc && \
  usermod -G users yaapc

VOLUME ["${CONFIG_DIR}"]

ENTRYPOINT ["/init"]
