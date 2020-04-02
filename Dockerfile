FROM docker:18-dind

ENV GITLAB_RUNNER_VERSION=12.9.0

RUN apk add --no-cache \
  bash \
  drill \
  dumb-init \
  curl \
  ca-certificates

RUN set -eux; \
  curl -sSL https://raw.githubusercontent.com/tobilg/mesosdns-resolver/master/mesosdns-resolver.sh -o /usr/local/bin/mesosdns-resolver && \
  chmod 0755 /usr/local/bin/mesosdns-resolver && \
  curl -SL --progress-bar --fail -o /usr/local/bin/gitlab-runner  \
    "https://gitlab-runner-downloads.s3.amazonaws.com/v${GITLAB_RUNNER_VERSION}/binaries/gitlab-runner-linux-amd64" && \
  chmod 0755 /usr/local/bin/gitlab-runner && \
  mkdir -p /etc/gitlab-runner/certs && \
  chmod -R 700 /etc/gitlab-runner

# Add wrapper script
COPY register_and_run.sh /

# Expose volumes
VOLUME ["/var/lib/docker", "/etc/gitlab-runner", "/home/gitlab-runner"]

ENTRYPOINT ["/usr/bin/dumb-init", "/register_and_run.sh"]
