# SPDX-FileCopyrightText: 2021 Belcan Advanced Solution
# SPDX-FileCopyrightText: 2021 Kaelan Thijs Fouwels <kaelan.thijs@fouwels.com>
#
# SPDX-License-Identifier: MIT

FROM alpine:3.15.0 as build
LABEL Maintainer="Kaelan Fouwels <kaelan.thijs@fouwels.com>"

RUN apk add --no-cache --virtual build_deps git build-base automake libtool autoconf zlib-dev pcre-dev openssl-dev

ENV NGINX_VERSION=1.21.4

RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && tar zxf nginx-${NGINX_VERSION}.tar.gz

ENV NGINX_OPTIONS="--with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-stream \
        --with-stream_ssl_module"

RUN cd nginx-${NGINX_VERSION} && ./configure ${NGINX_OPTIONS}
RUN cd nginx-${NGINX_VERSION} && make -j$(nproc)
RUN cd nginx-${NGINX_VERSION} && make install -j$(nproc)

RUN apk del build_deps

FROM alpine:3.15.0 as run

RUN apk add --no-cache zlib-dev openssl openssl-dev pcre-dev tree

COPY --from=build /usr/local/nginx /usr/local/nginx

# Create user to run rootless
RUN adduser --disabled-password nginx nginx
RUN mkdir -p /keys /config
RUN chown -R nginx:nginx  /usr/local/nginx /home/nginx /keys /config

USER nginx
ENV PATH=$PATH:/usr/local/nginx/sbin/

EXPOSE 80 443
ENTRYPOINT [ "nginx" ]
CMD ["-g", "daemon off;", "-c", "/config/nginx.conf"]