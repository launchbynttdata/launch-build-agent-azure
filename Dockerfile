ARG LAUNCH_PROVIDER="az"

FROM ghcr.io/launchbynttdata/launch-build-agent-base:latest as base
# This is needed to set up the build agent in use on a private AKS cluster
ENV AGENT_ALLOW_RUNASROOT="true" \
    TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./scripts/az-entry.sh  /azp/az-entry.sh

RUN chmod +x /azp/az-entry.sh \
    && curl -sL -o InstallAzureCLIDeb.sh https://aka.ms/InstallAzureCLIDeb \
    && chmod +x InstallAzureCLIDeb.sh \
    && ./InstallAzureCLIDeb.sh \
    && rm -f InstallAzureCLIDeb.sh

ENTRYPOINT ["/bin/bash", "-c", " /azp/az-entry.sh"]

FROM base AS final

RUN echo "Built image for: ${LAUNCH_PROVIDER}"
