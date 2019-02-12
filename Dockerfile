FROM debian:stretch

ENV \
    WEBHOOK_VERSION=2.6.9 \
    R10K_VERSION='3.1.0' \
	HOME=/home/g10k

EXPOSE 9000

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

COPY push-to-r10k.sh /push-to-r10k.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN echo StrictHostKeyChecking no >> /etc/ssh/ssh_config

COPY r10k.yaml.tmpl /etc/webhook/r10k.yaml.tmpl

# install nss_wrapper in case we need to fake /etc/passwd and /etc/group (i.e. for OpenShift)
RUN apt-get update && \
    apt-get install -y --no-install-recommends libnss-wrapper && \
	rm -rf /var/lib/apt/lists/*

COPY nss_wrapper.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

RUN mkdir -p /etc/puppetlabs/code/environments && \
    chgrp 0 -R /etc/puppetlabs/code && \
	chmod g=u -R /etc/puppetlabs/code
VOLUME ["/etc/puppetlabs/code"]

RUN mkdir -p ${HOME} && \
	chgrp 0 -R ${HOME} && \
	chmod g=u -R ${HOME}
USER 1000

ENTRYPOINT ["/docker-entrypoint.sh", "/usr/local/bin/webhook"]
CMD ["-hooks", "/etc/webhook/r10k.yaml.tmpl", "-template", "-verbose"]
