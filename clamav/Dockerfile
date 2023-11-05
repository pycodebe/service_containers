FROM debian:stable-slim

RUN apt-get update && apt-get install -y clamav cron

RUN freshclam

RUN touch /etc/cron.d/clamav-update /var/log/cron.log \ 
    && chmod 0644 /etc/cron.d/clamav-update \
    && echo "0 2 * * * root freshclam >> /var/log/cron.log 2>&1" > /etc/cron.d/clamav-update \
    && crontab /etc/cron.d/clamav-update

WORKDIR /data