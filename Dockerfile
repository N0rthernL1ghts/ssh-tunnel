FROM scratch AS rootfs

COPY --from=nlss/attr ["/usr/local/bin/attr", "/usr/local/bin/attr"]
COPY ["./rootfs", "/"]




FROM alpine:3.22
LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>"

RUN apk add --update --no-cache openssh-client \
    && adduser --shell /bin/false --disabled-password --gecos "SSH Tunnel User" --home "/app" "tunnel"

# Copy over rootfs and main script
COPY --from=rootfs ["/", "/"]

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