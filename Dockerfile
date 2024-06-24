ARG LAUNCH_PROVIDER="az"

FROM ghcr.io/launchbynttdata/launch-build-agent-base:latest as base
# This is needed to set up the build agent in use on a private AKS cluster
ENV AGENT_ALLOW_RUNASROOT="true" \
    TARGETARCH="linux-x64"

USER root

WORKDIR /azp/

COPY ./scripts/az-download.sh  /azp/az-download.sh
COPY ./scripts/az-entry.sh  /azp/az-entry.sh

RUN chmod +x /azp/az-entry.sh /azp/az-download.sh
RUN curl -vL -o InstallAzureCLIDeb.sh https://aka.ms/InstallAzureCLIDeb \
    && chmod +x InstallAzureCLIDeb.sh \
    && ./InstallAzureCLIDeb.sh \
    && rm -f InstallAzureCLIDeb.sh

RUN /azp/az-download.sh

ENTRYPOINT ["/bin/bash", "-c", " /azp/az-entry.sh"]

FROM base AS final

RUN echo "Built image for: ${LAUNCH_PROVIDER} with version ${AGENT_VERSION} of the Azure Agent"
