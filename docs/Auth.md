# Authentication Setup

This document details how the Comet Observatory is configured in such a way that both GPG and SSH use KeePassXC for authentication. We use the ability of gpg-agent to emulate an [OpenSSH agent](https://wiki.archlinux.org/title/GnuPG#SSH_agent).

On systemd user startup (after user login), the gpg-agent user service is started. Orthogonally, on DE launch, we launch KeePassXC.

Here is the GPG authentication process, with Git as an example client program:

```
git -> gpg -> gpg-agent (as systemd user service) -> pinentry-tty -> Secret Service D-Bus API -> KeePassXC
```

Here is the SSH authentication process:

```
ssh -> "ssh-agent" (actually gpg-agent as systemd user service) -> pinentry-tty -> Secret Service D-Bus API -> KeePassXC
```

Finally, here is the NetworkManager process:
```
nmcli -> NetworkManager -> networkmanager-openconnect -> nm-applet (offers agent) -> Secret Service D-Bus API -> KeePassXC
```
