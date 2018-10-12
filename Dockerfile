FROM alpine:3.8

ENV PGPOOL_VERSION 3.7.5
ENV PG_VERSION 10.5-r0

ENV PCP_PORT 9898
ENV PCP_USERNAME postgres
ENV PCP_PASSWORD postgres
ENV PGPOOL_PORT 5432
ENV PGPOOL_BACKENDS postgres:5432:10
ENV TRUST_NETWORK 0.0.0.0/0
ENV PG_USERNAME postgres
ENV PG_PASSWORD postgres

ENV NUM_INIT_CHILDREN 32
ENV MAX_POOL 4
ENV CHILD_LIFE_TIME 300
ENV CHILD_MAX_CONNECTIONS 0
ENV CONNECTION_LIFE_TIME 0
ENV CLIENT_IDLE_LIMIT 0

ADD docker-entrypoint.sh /

RUN set -x && \

    apk --update --no-cache add libpq=${PG_VERSION} \
        postgresql-client=${PG_VERSION} libffi-dev libffi-dev && \

    apk --update --no-cache add --virtual .build-dependencies \
        postgresql-dev=${PG_VERSION} linux-headers gcc make libgcc g++ && \

    mkdir -p "/var/run/pgpool/" "/etc/pgpool2/" && \

    cd "/tmp" && \
    wget "http://www.pgpool.net/mediawiki/images/pgpool-II-${PGPOOL_VERSION}.tar.gz" \
        -O - | tar -xz && \
    chown -R root:root "/tmp/pgpool-II-${PGPOOL_VERSION}" && \
    cd "/tmp/pgpool-II-${PGPOOL_VERSION}" && \
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info && \
    make && \
    make install && \
    rm -rf "/tmp/pgpool-II-${PGPOOL_VERSION}" && \

    apk del .build-dependencies && \

    wget https://github.com/noqcks/gucci/releases/download/0.1.0/gucci-v0.1.0-linux-amd64 \
        -O "/usr/bin/gucci" && \
    chmod +x "/usr/bin/gucci" && \

    chmod +x "/docker-entrypoint.sh"

ADD config/pcp.conf.gucci /usr/share/pgpool2/pcp.conf.gucci
ADD config/pgpool.conf.gucci /usr/share/pgpool2/pgpool.conf.gucci
ADD config/pool_hba.conf.gucci /usr/share/pgpool2/pool_hba.conf.gucci

ENTRYPOINT [ "/bin/sh", "/docker-entrypoint.sh" ]

CMD ["pgpool", "-n", "-f", "/etc/pgpool.conf", "-F", "/etc/pcp.conf", "-a", "/etc/pool_hba.conf"]
