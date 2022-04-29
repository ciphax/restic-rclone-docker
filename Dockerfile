FROM alpine:latest@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454 AS extractor

ARG TARGETOS
ARG TARGETARCH
ARG RESTIC_VERSION=0.13.1
ARG RCLONE_VERSION=1.58.1

RUN apk add --no-cache bzip2 unzip

ADD https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_${TARGETOS}_${TARGETARCH}.bz2 /tmp/restic.bz2
ADD https://github.com/rclone/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-${TARGETOS}-${TARGETARCH}.zip /tmp/rclone.zip

WORKDIR /out

RUN bzcat /tmp/restic.bz2 > restic
RUN chmod +x restic

RUN unzip /tmp/rclone.zip -d /tmp
RUN mv /tmp/rclone-v*/rclone rclone

FROM alpine:latest@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454

RUN apk add --no-cache ca-certificates fuse openssh-client tzdata

COPY --from=extractor /out/* /usr/bin/

WORKDIR /data
ENTRYPOINT ["/usr/bin/restic"]
