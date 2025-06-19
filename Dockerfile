FROM alpine:latest@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS extractor

ARG TARGETOS
ARG TARGETARCH
# renovate: datasource=github-releases depName=restic/restic extractVersion=v(?<version>.*)$
ARG RESTIC_VERSION=0.18.0
# renovate: datasource=github-releases depName=rclone/rclone extractVersion=v(?<version>.*)$
ARG RCLONE_VERSION=1.70.1

RUN apk add --no-cache bzip2 unzip

ADD https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_${TARGETOS}_${TARGETARCH}.bz2 /tmp/restic.bz2
ADD https://github.com/rclone/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-${TARGETOS}-${TARGETARCH}.zip /tmp/rclone.zip

WORKDIR /out

RUN bzcat /tmp/restic.bz2 > restic
RUN chmod +x restic

RUN unzip /tmp/rclone.zip -d /tmp
RUN mv /tmp/rclone-v*/rclone rclone

FROM alpine:latest@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

RUN apk add --no-cache ca-certificates fuse openssh-client tzdata

COPY --from=extractor /out/* /usr/bin/

WORKDIR /data
ENTRYPOINT ["/usr/bin/restic"]
