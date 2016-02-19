FROM jmcarbo/webhook

MAINTAINER mickael.canevet@camptocamp.com

EXPOSE 9000

ENV RELEASE=jessie

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

ENV PUPPET_AGENT_VERSION 1.3.4-1${RELEASE}
ENV PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

RUN apt-get update \
  && apt-get install -y curl locales-all \
  && curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-${RELEASE}.deb \
  && dpkg -i puppetlabs-release-pc1-${RELEASE}.deb \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
  && apt-get install -y --force-yes \
    puppet-agent=$PUPPET_AGENT_VERSION \
  && rm -rf /var/lib/apt/lists/*

# Configure mcollective client
RUN sed -i -e 's/stomp1/activemq/' -e 's/6163/61613/' /etc/puppetlabs/mcollective/client.cfg
COPY plugins/ /opt/puppetlabs/mcollective/plugins/

RUN useradd -r -s /bin/false r10k
COPY r10k.json /etc/webhook/r10k.json
RUN chown -R r10k. /etc/webhook
USER r10k

COPY push-to-r10k.sh /push-to-r10k.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
