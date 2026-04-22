FROM golang:1.26.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    redis-tools \
    awscli \
    unzip \
    gnupg \
    curl \
  && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com trixie main" \
     > /etc/apt/sources.list.d/hashicorp.list \
  && apt-get update && apt-get install -y --no-install-recommends vault etcd-client --fix-missing \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /confd
COPY . .
RUN git config --global --add safe.directory /confd && make build && make install

CMD ["bash", "test/run-integration-tests.sh"]
