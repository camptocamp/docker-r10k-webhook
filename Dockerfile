FROM jmcarbo/webhook

MAINTAINER mickael.canevet@camptocamp.com

RUN useradd -r -s /bin/false r10k

USER r10k

COPY r10k.json /etc/webhook/r10k.json
COPY r10k-inetd-deploy.sh /r10k-inetd-deploy.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
