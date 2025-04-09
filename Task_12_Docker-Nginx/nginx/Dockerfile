FROM nginx:1.27.4-alpine

EXPOSE 80 443

ARG EMAIL
ARG DOMAIN
ARG CERT_TYPE
ARG PROJECT_DIR
ARG CERTIFICATE_ID
ARG IAM_TOKEN

ENV EMAIL=$EMAIL
ENV DOMAIN=$DOMAIN
ENV PROJECT_DIR=$PROJECT_DIR
ENV CERT_TYPE=$CERT_TYPE
ENV CERTIFICATE_ID=$CERTIFICATE_ID
ENV IAM_TOKEN=$IAM_TOKEN

RUN apk add --no-cache bash
RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www

RUN mkdir -p /var/run/nginx && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /etc/letsencrypt/live

RUN apk add --no-cache certbot certbot-nginx python3 openssl lnav nano curl jq

COPY --chown=www:www nginx_serv/ /sites/starter/                
COPY --chown=www:www nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=www:www nginx/sites-enabled/ /etc/nginx/sites-enabled/
COPY --chown=www:www entrypoint-letsencrypt-cert.sh /entrypoint-letsencrypt-cert.sh
COPY --chown=www:www entrypoint-yandex-cert.sh /entrypoint-yandex-cert.sh

RUN chown -R www:www /var/run/nginx && \
    chown -R www:www /var/cache/nginx && \
    chown -R www:www /etc/letsencrypt && \
    chmod -R 770 /var/run/nginx && \
    chmod -R 770 /var/cache/nginx && \
    chmod -R 770 /etc/letsencrypt && \
    chmod -R 770 /etc/nginx/nginx.conf && \
    chmod 770 /etc/letsencrypt/live && \
    chmod -R 770 /var/run && \
    chown -R www:www /var/run && \
    touch /var/run/nginx.pid && \
    chown -R www:www /var/run/nginx.pid

RUN if ! getent group www; then addgroup -S www; fi && \
    if ! getent passwd www; then adduser -S www -G www-data; fi


VOLUME ["/etc/letsencrypt", "/certbot/www"]


RUN chmod +x /entrypoint-letsencrypt-cert.sh \
            /entrypoint-yandex-cert.sh


ENTRYPOINT ["/bin/sh", "-c", "if [ \"$CERT_TYPE\" = 'yandex' ]; then exec /entrypoint-yandex-cert.sh; else exec /entrypoint-letsencrypt-cert.sh; fi"]
RUN apk add --no-cache su-exec
#CMD ["sh", "-c", "exec su-exec www:www nginx -g 'daemon off;'"]
#USER www
