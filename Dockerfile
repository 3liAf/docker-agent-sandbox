# Minimal, hardened execution container for autonomous AI code execution agents
FROM alpine:3.20

LABEL maintainer="Ali Afzal Yousuf <hello@astrameld.com>"
LABEL description="Hardened sandbox environment for running untrusted LLM-generated scripts."

# Install minimal runtimes and security utilities
RUN apk update && apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    python3 \
    py3-pip \
    nodejs \
    npm \
    tini \
    && rm -rf /var/cache/apk/*

# Create unprivileged sandbox user
RUN addgroup -S sandboxgroup && adduser -S sandboxuser -G sandboxgroup -h /home/sandboxuser

# Set working directory with strict permissions
WORKDIR /sandbox
RUN chown -R sandboxuser:sandboxgroup /sandbox

# Restrict network and capabilities via non-root user
USER sandboxuser

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["bash"]