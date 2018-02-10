FROM alpine:3.6

ARG version=3.5.1
ARG buildhost=https://github.com/bitlbee/bitlbee/archive
ARG tar_filename=${version}.tar.gz

ENV BITLBEE_BUILD_DIR=/tmp/bitlbee

VOLUME ["/usr/local/etc/bitlbee", "/usr/local/lib/bitlbee", "/var/lib/bitlbee"]

COPY entrypoint.sh /entrypoint.sh

RUN apk update \
 && apk add --no-cache \
            --virtual build \
            wget \
            gcc \
            make \
 && apk add --no-cache \
            ca-certificates \
            glib-dev \
            gnutls-dev \
            gnutls \
            libc-dev \
            libgcrypt-dev \
            su-exec \
 && update-ca-certificates \
 && wget ${buildhost}/${tar_filename} \
 && mkdir -p $BITLBEE_BUILD_DIR \
 && tar xvf "${tar_filename}" -C $BITLBEE_BUILD_DIR --strip 1 \
 && rm "${tar_filename}" \
 && cd $BITLBEE_BUILD_DIR \
 && ./configure --ssl=gnutls \
 && make \
 && make install \
 && make install-dev \
 && rm -r $BITLBEE_BUILD_DIR \
 && apk del build

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bitlbee", "-Dnv"]

EXPOSE 6667
