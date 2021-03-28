FROM alpine:edge

RUN apk add --no-cache curl jq rclone
COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
