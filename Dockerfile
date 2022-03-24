FROM alpine:latest@sha256:ceeae2849a425ef1a7e591d8288f1a58cdf1f4e8d9da7510e29ea829e61cf512 AS extractor

ARG TARGETOS
ARG TARGETARCH
ARG RESTIC_VERSION=0.12.1
ARG RCLONE_VERSION=1.58.0

RUN apk add --no-cache bzip2 unzip

ADD https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_${TARGETOS}_${TARGETARCH}.bz2 /tmp/restic.bz2
ADD https://github.com/rclone/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-${TARGETOS}-${TARGETARCH}.zip /tmp/rclone.zip

WORKDIR /out

RUN bzcat /tmp/restic.bz2 > restic
RUN chmod +x restic

RUN unzip /tmp/rclone.zip -d /tmp
RUN mv /tmp/rclone-v*/rclone rclone

FROM alpine:latest@sha256:ceeae2849a425ef1a7e591d8288f1a58cdf1f4e8d9da7510e29ea829e61cf512

RUN apk add --no-cache ca-certificates fuse openssh-client tzdata

COPY --from=extractor /out/* /usr/bin/

WORKDIR /data
ENTRYPOINT ["/usr/bin/restic"]
