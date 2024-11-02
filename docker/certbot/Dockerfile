FROM certbot/certbot:v1.27.0

COPY certify-init.sh /certify-init.sh
RUN chmod +x /certify-init.sh

ENTRYPOINT []

CMD ["certbot", "renew"]
