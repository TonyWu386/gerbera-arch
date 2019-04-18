FROM archlinux/base
ENV container docker

RUN pacman -Sy --noconfirm base-devel git go libxml2 libupnp

RUN useradd -m gerbera && echo "gerbera ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN sudo -H -u gerbera bash -c 'cd /home/gerbera; git clone "https://aur.archlinux.org/yay.git"' && \
    sudo -H -u gerbera bash -c 'cd /home/gerbera/yay; makepkg PKGBUILD'

RUN pacman -U --noconfirm /home/gerbera/yay/yay-*.tar.xz

RUN LINE=$(grep -Fn '[multilib]' /etc/pacman.conf | awk -F: '{ print $1 }') && \
    sed -i "$LINE,$(expr $LINE + 1)s/.//" /etc/pacman.conf && \
    pacman -Sy

RUN sudo -H -u gerbera bash -c 'yay -S --noconfirm gerbera' && \
    sudo -H -u gerbera bash -c 'mkdir /home/gerbera/.config/gerbera' && \
    sudo -H -u gerbera bash -c 'gerbera --create-config > /home/gerbera/.config/gerbera/config.xml'

RUN LINE=$(grep -Fn 'gerbera' /etc/sudoers | awk -F: '{ print $1 }') && \
    sed -i "$LINE d" /etc/sudoers && \
    pacman -R --noconfirm yay && \
    rm -r /home/gerbera/yay

EXPOSE 1900/udp 49152
USER gerbera
ENTRYPOINT [ "gerbera" ]
