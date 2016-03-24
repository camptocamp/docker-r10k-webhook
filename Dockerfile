FROM jmcarbo/webhook

MAINTAINER mickael.canevet@camptocamp.com

EXPOSE 9000

ENV RELEASE=jessie

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

ENV PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

RUN apt-get update \
  && apt-get install -y curl locales-all \
  && curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-${RELEASE}.deb \
  && dpkg -i puppetlabs-release-pc1-${RELEASE}.deb \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
  && apt-get install -y puppet-agent \
  && rm -rf /var/lib/apt/lists/*

# Configure mcollective client
RUN sed -i -e 's/stomp1/activemq/' \
           -e 's/6163/61613/' \
           -e 's/^securityprovider = .*$/securityprovider = ssl/' \
           /etc/puppetlabs/mcollective/client.cfg
COPY plugins/ /opt/puppetlabs/mcollective/plugins/

RUN useradd -r -s /bin/false r10k
COPY r10k.json /etc/webhook/r10k.json
RUN chown -R r10k. /etc/webhook
RUN chown -R r10k. /etc/puppetlabs/mcollective/client.cfg
RUN mkdir -p /etc/puppetlabs/mcollective/ssl
RUN chown -R r10k. /etc/puppetlabs/mcollective/ssl
USER r10k

COPY push-to-r10k.sh /push-to-r10k.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

ENTRYPOINT ["/docker-entrypoint.sh"]

