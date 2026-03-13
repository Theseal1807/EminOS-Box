# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/bazzite-deck:stable

RUN echo 'NAME="EminOS"' > /usr/lib/os-release && \
    echo 'PRETTY_NAME="EminOS"' >> /usr/lib/os-release && \
    echo 'ID=eminos' >> /usr/lib/os-release && \
    echo 'ID_LIKE="fedora"' >> /usr/lib/os-release && \
    echo 'VERSION="1"' >> /usr/lib/os-release && \
    echo 'VERSION_ID="1"' >> /usr/lib/os-release && \
    echo 'HOME_URL="https://github.com/theseal1807/eminos-box"' >> /usr/lib/os-release && \
    echo 'VARIANT="EminOS Box"' >> /usr/lib/os-release


## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### [IM]MUTABLE /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
