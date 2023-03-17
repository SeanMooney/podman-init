FROM registry.access.redhat.com/ubi9/podman:9.1.0-14

# ubi 9 init container content start do not modify
CMD ["/sbin/init"]
STOPSIGNAL SIGRTMIN+3
#mask systemd-machine-id-commit.service - partial fix for https://bugzilla.redhat.com/show_bug.cgi?id=1472439
RUN systemctl mask systemd-remount-fs.service dev-hugepages.mount sys-fs-fuse-connections.mount systemd-logind.service \
    getty.target console-getty.service systemd-udev-trigger.service systemd-udevd.service systemd-random-seed.service \
    systemd-machine-id-commit.service
RUN dnf -y install procps-ng && dnf clean all
# ubi 9 init container content end

# add customization here
RUN dnf -y install sudo openssh openssh-server && dnf clean all
RUN groupadd stack && useradd -g stack -s /bin/bash -m stack && ( umask 226 && echo "stack ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/50_stack_sh ) && mkdir /home/stack/.ssh
COPY --chown=stack:stack ./stack_ed25519 /home/stack/.ssh/stack_ed25519
COPY --chown=stack:stack ./stack_ed25519.pub /home/stack/.ssh/stack_ed25519.pub
COPY --chown=stack:stack ./stack_ed25519.pub /home/stack/.ssh/authorized_keys
RUN chmod 600 /home/stack/.ssh/*
EXPOSE 22/tcp
