# gerbera-arch
Arch Linux-based Docker image of the [Gerbera](https://github.com/gerbera/gerbera) media server.

Uses the Gerbera PKGBUILD [from the AUR](https://aur.archlinux.org/packages/gerbera).

Pre-built image on [Docker Hub](https://hub.docker.com/r/tw386/gerbera-arch).

Example usage:

    docker run -d \
        -v /path/to/config/dir:/home/gerbera/.config/gerbera \
        -v /path/to/media/dir:/media:ro \
        -p 49152:49152 \
        -p 1900:1900/udp \
        -m 256M \
        gerbera-arch
