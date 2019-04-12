FROM debian:stretch

EXPOSE 9000

ENV RELEASE=jessie \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH \
    WEBHOOK_VERSION=2.6.9 \
    R10K_VERSION='2.6.5'

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

RUN apt-get update \
  && apt-get install -y git ca-certificates curl unzip rubygems \
  && rm -rf /var/lib/apt/lists/*

# Install r10k
RUN gem install specific_install --no-ri --no-rdoc \
  && gem specific_install -l https://github.com/puppetlabs/r10k.git -b $R10K_VERSION

# Install webhook
RUN curl -L https://github.com/adnanh/webhook/releases/download/${WEBHOOK_VERSION}/webhook-linux-amd64.tar.gz -o webhook-linux-amd64.tar.gz \
	&& tar xzf webhook-linux-amd64.tar.gz \
	&& mv webhook-linux-amd64/webhook /usr/local/bin \
	&& chmod +x /usr/local/bin/webhook \
	&& rm webhook-linux-amd64.tar.gz

RUN useradd -r -s /bin/false r10k
RUN mkdir /etc/webhook \
    && chown -R r10k. /etc/webhook
RUN chown -R r10k. /etc/puppetlabs/mcollective/client.cfg
RUN mkdir -p /etc/puppetlabs/mcollective/ssl
RUN chown -R r10k. /etc/puppetlabs/mcollective/ssl
USER r10k

COPY push-to-r10k.sh /push-to-r10k.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
COPY r10k.yaml.tmpl /etc/webhook/r10k.yaml.tmpl

ENTRYPOINT ["/docker-entrypoint.sh"]
