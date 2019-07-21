FROM node:10-alpine
RUN set -ex; \
    \
    apk add --no-cache \
        tini \
    ; \
    \
    npm install -g coffeescript@^2.4.1; \
    \
    addgroup -g 101 -S taiga; \
    adduser -D -H -g taiga -G taiga -s /sbin/nologin -S -u 101 taiga; \
    \
    rm -rf /root/.config /root/.npm /var/cache/apk/*
ENV TAIGA_EVENTS_VERSION=3583834aba595006f290928470b91bd6e2a71a9e \
    TAIGA_EVENTS_SHA256SUM=6c0b1e35ecc8d71c9319f1093fc73888b617c3cba299b0168641b405d2a8f3b7
RUN set -ex; \
    \
    wget -q -O taiga-events.tar.gz \
        https://github.com/taigaio/taiga-events/archive/${TAIGA_EVENTS_VERSION}.tar.gz; \
    echo "${TAIGA_EVENTS_SHA256SUM}  taiga-events.tar.gz" | sha256sum -c; \
    tar -xzf taiga-events.tar.gz; \
    rm -r taiga-events.tar.gz; \
    mv taiga-events-${TAIGA_EVENTS_VERSION} /opt/taiga-events; \
    find /opt/taiga-events -type f -exec chmod 644 -- {} +; \
    npm install -g /opt/taiga-events; \
    mkdir -p /etc/opt/taiga-events; \
    sed -i 's/8888/8080/' /opt/taiga-events/config.example.json; \
    mv /opt/taiga-events/config.example.json /etc/opt/taiga-events/config.json; \
    touch /var/log/taiga-events.log; \
    chown taiga:taiga /var/log/taiga-events.log; \
    \
    rm -r /root/.config /root/.npm
COPY files /
WORKDIR /opt/taiga-events
USER taiga
ENTRYPOINT ["tini", "--", "taiga-events"]
CMD ["--config", "/etc/opt/taiga-events/config.json"]
EXPOSE 8080
