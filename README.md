# Restic Docker image with Rclone
An alpine based docker image that contains the latest released binaries of [restic](https://github.com/restic/restic) and [rclone](https://github.com/rclone/rclone). The image gets automatically updated when there is a new release.

## Usage
```sh
docker run --rm -it \
    -v ~/.config/rclone:/root/.config/rclone \
    -v /dir/to/backup:/data \
    -e RESTIC_REPOSITORY=rclone:service:path \
    ghcr.io/kegato/restic-rclone-docker:latest \
    backup .
```

### Available Platforms
- linux/amd64
- linux/arm64

## Acknowledgments
This repo is based on
- restic
  - [Website](https://restic.net/)
  - [Github](https://github.com/restic/restic)
- rclone
  - [Website](https://rclone.org/)
  - [Github](https://github.com/rclone/rclone)
