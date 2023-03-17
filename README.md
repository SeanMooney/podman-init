# podman-init
A minimal ubi 9 contianer with systemd, sshd and podman

This should only used for testing and not in production as it inclues
the publically avaiable ssh public and private key contained in this repo

A stack user is created in the container with passwordless sudo
and the ssh public key is added to the stack users authorized_keys to enable
ssh login with the provided keys.

# using the container

a "test-node" can be created using the following command
```
podman run -it -d  --name test-node -p 50022:22 --privileged podman-init
```
alternitivly instead of specifying the host port to use for ssh -P can be used
to have it auto selected.
