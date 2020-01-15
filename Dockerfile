FROM alpine:3.11
LABEL maintainer="chruth"

ENV \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  CONFIG_DIR="/config" \
  APP_DIR="/app" \
  PUID="1000" \
  PGID="1000" \
  TZ="Europe/Berlin"

ARG S6_VERSION="1.22.1.0"

# install packages
RUN apk add --update --no-cache \
    bash \
    coreutils \
    shadow \
    tzdata \
    ca-certificates \
    curl && \
    # s6 overlay download
    curl -o /tmp/s6overlay.tar.gz -sL \
    "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz" && \
    tar xzf /tmp/s6overlay.tar.gz -C / && \
    # cleanup
    apk del curl && \
    rm -rf /tmp/*

# create user
RUN \
  useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false yaapc && \
  usermod -G users yaapc

VOLUME ["${CONFIG_DIR}"]

ENTRYPOINT [ "/init" ]