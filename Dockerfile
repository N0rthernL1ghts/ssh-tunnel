ARG ALPINE_VERSION=3.12

FROM --platform=${TARGETPLATFORM} nlss/base-alpine:${ALPINE_VERSION}
LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>"

RUN apk add --update --no-cache openssh-client \
    && adduser --shell /bin/false --disabled-password --gecos "SSH Tunnel User" --home "/app" "tunnel" \
    && wget -O /usr/local/bin/attr https://gist.githubusercontent.com/xZero707/7a3fb3e12e7192c96dbc60d45b3dc91d/raw/44a755181d2677a7dd1c353af0efcc7150f15240/attr.sh \
    && chmod a+x /usr/local/bin/attr


# Copy over rootfs and main script
COPY ["./rootfs", "/"]

RUN mkdir -p /secret \
    && attr /secret/ true tunnel:tunnel 0770 2771 \
    && attr /app/ true tunnel:tunnel 0770 2771

WORKDIR "/app"

ENV TUNNEL_SERVICE               ""
ENV SSH_HOST                     ""
ENV SSH_PORT                     22
ENV SSH_USER                     root
ENV SERVICE_EXPOSE_PORT          5100
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2