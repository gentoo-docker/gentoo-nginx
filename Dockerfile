FROM euskadi31/gentoo-portage:latest

MAINTAINER Axel Etcheverry <axel@etcheverry.biz>

RUN mkdir /var/www
RUN mkdir -p /etc/nginx/server.d/
RUN echo "www-servers/nginx ~amd64" >> /etc/portage/package.keywords
RUN echo "media-libs/gd jpeg png" >> /etc/portage/package.use
RUN echo "www-servers/nginx http http-cache ipv6 libatomic pcre ssl vim-syntax" >> /etc/portage/package.use
RUN echo "NGINX_MODULES_HTTP=\"access auth_basic browser cache_purge charset empty_gif fastcgi geo gunzip gzip gzip_static headers_more image_filter limit_conn limit_req map memcached proxy realip referer rewrite scgi spdy ssi upload_progress upstream_ip_hash userid uwsgi\"" >> /etc/portage/make.conf
RUN emerge www-servers/nginx

# forward request logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY drop.conf /etc/nginx/drop.conf
COPY optimize.conf /etc/nginx/optimize.conf
COPY realip.conf /etc/nginx/realip.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-config /etc/inid.d/nginx-config

EXPOSE 80 443

VOLUME /var/www

WORKDIR /var/www

CMD ["nginx", "-g", "daemon off;"]
