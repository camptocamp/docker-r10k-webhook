FROM jmcarbo/webhook

MAINTAINER mickael.canevet@camptocamp.com

EXPOSE 9000

ENV RELEASE=jessie
ENV PUPPET_AGENT_VERSION 1.3.4-1${RELEASE}

RUN useradd -r -s /bin/false r10k
RUN apt-get update \
  && apt-get install -y curl locales-all \
  && curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-${RELEASE}.deb \
  && dpkg -i puppetlabs-release-pc1-${RELEASE}.deb \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
  && apt-get install -y --force-yes \
    puppet-agent=$PUPPET_AGENT_VERSION \
  && rm -rf /var/lib/apt/lists/*

USER r10k

COPY r10k.json /etc/webhook/r10k.json
COPY push-to-r10k.sh /push-to-r10k.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
