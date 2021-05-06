FROM alpine

RUN apk add --update --no-cache openssh-client \
    && adduser --shell /bin/false --disabled-password --gecos "SSH Tunnel User" --home "/app" "tunnel" \
    && wget -O /usr/local/bin/attr https://gist.githubusercontent.com/xZero707/7a3fb3e12e7192c96dbc60d45b3dc91d/raw/44a755181d2677a7dd1c353af0efcc7150f15240/attr.sh \
    && chmod a+x /usr/local/bin/attr


# Copy over rootfs and main script
COPY ["./rootfs", "/"]
COPY ["./src/tunnel-service", "/app/"]

RUN mkdir -p /secret \
    && attr /secret/ true tunnel:tunnel 0770 2771 \
    && attr /app/ true tunnel:tunnel 0770 2771

# Setup
CMD ["/app/tunnel-service"]

WORKDIR "/app"

USER tunnel
