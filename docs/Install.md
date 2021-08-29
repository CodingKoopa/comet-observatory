# System Installation

This document loosely describes the process of installing a system with comet-observatory. It's certainly not meant to be *used* as much as it is a reminder of what to do, for myself.
1. Follow the [Installation guide](https://wiki.archlinux.org/title/Installation_guide) to install Arch Linux, ending off in a chroot in the base system.
2. Create the necessary directories on the drives, if not present (see `setup.sh`).
3. Install the dependencies needed for the comet-observatory setup:
```
# pacman -S git sudo lolcat lsd ntfs-3g pacman-contrib expac
# pacman -S --asdep pinentry
```
3. Create the install user, inputting `$USER`:
```
# useradd -m -G wheel -s /usr/bin/bash "$USER"
```
4. Set the password of the new user.
```sh
passwd "$USER"
```
1. Setup sudo to allow the `wheel` group to execute commands.
```
# EDITOR=nano visudo
```
5.  Change to the user account.
```
# su $USER
```
6. Make a clone of the repo, if one doesn't already exist on the desired drive:
```
$ git clone https://gitlab.com:<personal_access_token>@gitlab.com/CodingKoopa/comet-observatory.git
```
7. Run setup-user as `$USER`. Anything that needs the dbus, such as the activation of systemd services, will not work right now since we're still in the chroot.
8. See what `.old` files there are, from the user setup:
```
$ find $HOME -name "*.old" -print
```
9. If **it seems** safe going by the last step, delete the `.old` files:
```
$ find $HOME -name "*.old" -delete
```
10. Run setup-system as `root`. The same caveat about the dbus applies here too.
11. If applicable, add boot entries for this new installation to NVRAM:
```
# update-efi
```
12. Boot into new system, and fix whatever stupid things you missed.
13. Enable NetworkManager so that setup can be ran again (remember that systemd services couldn't be activated before).
```
# systemctl enable --now NetworkManager.service
```
13. Setup an internet connection with NetworkManager in your hopefully now pretty-much functioning desktop environment.
14. Setup a Kwallet without GPG, and add an entry for `KeepassXC/Passwords.kbdx`.
15. Re-run both setups to finish off what couldn't be done before.
16. Install the [Firefox config](../../config/firefox.js) to your new Firefox user profile.
