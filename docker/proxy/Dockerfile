FROM nginx:1.23.0-alpine

COPY ./nginx/* /etc/nginx/

COPY ./run.sh /run.sh

RUN mkdir -p /etc/letsencrypt
COPY ./nginx/options-ssl-nginx.conf /etc/letsencrypt/options-ssl-nginx.conf

ENV APP_HOST=app
ENV APP_PORT=9000

RUN apk add --no-cache openssl bash
RUN chmod +x /run.sh

VOLUME /vol/static
VOLUME /vol/www

CMD ["/run.sh"]