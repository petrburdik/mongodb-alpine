# *****************************************************************************
# mongodb
#
# - package based on alpinelinux and compatible with grsec
#
# *****************************************************************************
FROM alpine:3.8

LABEL	maintainer="Petr Burdik, Sunset Media s.r.o. <petr.burdik@me.com>" \
    description="Alpine linux 3.8, Mongodb 4.0" \
    version="1.0"

ENV	ALPINE_LINUX_VERSION 3.8 \
    ENV MONGO_MAJOR 4.0 \
    ENV MONGO_VERSION 4.0.0

EXPOSE	27017

RUN echo "@edge http://dl-3.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update upgrade && \
    apk add --no-cache bash && \
    cd /tmp && \
    apk fetch -s boost-system > boost-system.apk && \
    apk add --no-cache --no-network --allow-untrusted /tmp/boost-system.apk && \
    apk fetch -s boost-filesystem > boost-filesystem.apk && \
    apk add --no-cache --no-network --allow-untrusted /tmp/boost-filesystem.apk && \
    apk fetch -s boost-iostreams > boost-iostreams.apk && \
    apk add --no-cache --no-network --allow-untrusted /tmp/boost-iostreams.apk && \
    apk fetch -s boost-program_options > boost-program_options.apk && \
    apk add --no-cache --no-network --allow-untrusted /tmp/boost-program_options.apk && \
    rm /tmp/*.apk && \
    apk add --no-cache mongodb && \
    apk add --no-cache mongodb-tools

RUN mkdir -p /data/db /data/configdb /data/backup \
    && chown -R mongodb:mongodb /data/

COPY [ "docker-entrypoint.sh", "/docker-entrypoint.sh" ]

VOLUME /data/db /data/configdb /data/backup

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "mongod", "--bind_ip", "0.0.0.0" ]

