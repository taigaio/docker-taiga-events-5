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
RUN set -exo pipefail; \
    \
    apk add --no-cache --virtual .build-deps \
        jq \
        moreutils \
    ; \
    \
    wget -q -O taiga-events.tar.gz \
        https://github.com/taigaio/taiga-events/archive/${TAIGA_EVENTS_VERSION}.tar.gz; \
    echo "${TAIGA_EVENTS_SHA256SUM}  taiga-events.tar.gz" | sha256sum -c; \
    tar -xzf taiga-events.tar.gz; \
    rm -r taiga-events.tar.gz; \
    mv taiga-events-${TAIGA_EVENTS_VERSION} /opt/taiga-events; \
    cd /opt/taiga-events; \
    find . -type f -exec chmod 644 '{}' +; \
    cat package.json | \
        # Make sure development dependencies are not installed
        jq 'del(.devDependencies)' | \
        # Fix security vulnerabilities
        jq '.dependencies["base64-url"] = "^2.3.2" | .dependencies.ws = "^7.1.1"' | \
        sponge package.json; \
    npm install; \
    rm package-lock.json; \
    mkdir -p /etc/opt/taiga-events; \
    sed -i 's/8888/8080/' config.example.json; \
    mv config.example.json /etc/opt/taiga-events/config.json; \
    cd -; \
    touch /var/log/taiga-events.log; \
    chown taiga:taiga /var/log/taiga-events.log; \
    \
    apk del .build-deps; \
    rm -rf /root/.config /root/.npm /var/cache/apk/*
COPY files /
WORKDIR /opt/taiga-events
USER taiga
ENTRYPOINT ["tini", "--", "taiga-events"]
CMD ["--config", "/etc/opt/taiga-events/config.json"]
EXPOSE 8080
