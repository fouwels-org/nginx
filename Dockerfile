FROM alpine:3.13.5 as build
LABEL Maintainer="Kaelan Fouwels <kaelan.fouwels@lagoni.co.uk>"

RUN apk add --no-cache --virtual build_deps git build-base automake libtool autoconf zlib-dev pcre-dev openssl-dev

ENV NGINX_VERSION=1.19.10

RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar zxf nginx-${NGINX_VERSION}.tar.gz && mv nginx-${NGINX_VERSION} nginx

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

RUN cd nginx && ./configure ${NGINX_OPTIONS}
RUN cd nginx && make
RUN cd nginx && make install

RUN apk del build_deps

FROM alpine:3.13.5 as run

RUN apk add --no-cache zlib-dev openssl pcre-dev

COPY --from=build /usr/local /usr/local

# Create  user to run rootless
RUN adduser --disabled-password nginx nginx
RUN chown -R nginx:nginx  /home/nginx
RUN chown -R nginx:nginx  /usr/local/nginx

RUN apk add tree
USER nginx
ENV PATH=$PATH:/usr/local/nginx/sbin/

ENTRYPOINT [ "/usr/local/nginx/sbin/nginx" ]
CMD ["-g", "daemon off;", "-c", "/config/nginx.conf"]