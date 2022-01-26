FROM alpine:3.14
LABEL maintainer="chruth"

ENV \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  CONFIG_DIR="/config" \
  APP_DIR="/app" \
  PUID="1000" \
  PGID="1000" \
  TZ="Europe/Berlin"

ARG S6_VERSION="3.0.0.0-1"
ARG ARCH

# install packages
RUN apk add --update --no-cache \
    bash \
    coreutils \
    shadow \
    tzdata \
    ca-certificates \
    curl && \
    # create app directory
    mkdir "${APP_DIR}" && \
    # s6 overlay download
    curl -o /tmp/s6overlay.tar.xz -sL \
    "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${ARCH}-${S6_VERSION}.tar.xz" && \
    tar -xJf /tmp/s6overlay.tar.xz -C / && \
    # cleanup
    apk del curl && \
    rm -rf /tmp/*

# create user
RUN \
  useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false yaapc && \
  usermod -G users yaapc

VOLUME ["${CONFIG_DIR}"]

ENTRYPOINT [ "/init" ]
