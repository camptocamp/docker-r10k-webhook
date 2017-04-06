FROM debian:jessie

EXPOSE 9000

ENV RELEASE=jessie \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH \
    GOVERSION="1.8" \
    GOPATH="/go" \
    GOROOT="/goroot"

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

# Install webhook
RUN apt-get update \
    && apt-get -y install git curl \
    && apt-get install -y ca-certificates \
    && curl https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz | tar xzf - \
    && mv /go ${GOROOT} \
    && ${GOROOT}/bin/go get github.com/raphink/webhook \
    && rm -rf go${GOVERSION}.linux-amd64.tar.gz ${GOROOT} \
    && apt-get clean

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
