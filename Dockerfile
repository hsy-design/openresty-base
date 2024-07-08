ARG TAG=1.25.3.1-1-bookworm-fat
FROM openresty/openresty:${TAG}

ENV TZ=Asia/Hong_Kong \
    LANG=en_US.UTF-8

RUN sed -i 's#deb.debian.org#mirrors.tuna.tsinghua.edu.cn#g' /etc/apt/sources.list.d/debian.sources

RUN apt update \
    && apt install -y --no-install-recommends htop bpytop nano vim ncat telnet curl tcptraceroute traceroute tcpdump lsof tree unzip tar dnsutils jattach jq\
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN chmod 755 /docker-entrypoint.sh

COPY nginx.conf /etc/openresty/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY 01-init.sh /docker-entrypoint.d/01-init.sh
RUN rm -f /bin/sh && ln -sf /bin/bash /bin/sh \
 && ln -sf  /usr/local/openresty/nginx/conf /etc/nginx \
 && mkdir -p /etc/nginx/sites-enabled \
 && mkdir -p /etc/nginx/streams-enabled \
 && mkdir -p /etc/nginx/ssl \
 && chmod -R 755 /etc/nginx \
 && mkdir -p /app \
 && chmod -R 755 /app

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]