# Backups

This document discusses how I share and back up the data on my desktop and laptop.

The naïve solution to data backups is to have the two client devices both partake in bidirectional syncing with a [file hosting service](https://en.wikipedia.org/wiki/Comparison_of_file_hosting_services).

This is inefficient in two key ways:
- Even if the two devices are on the same network, the data produced by one will be downloaded from the cloud service.
- Incremental changes are not transferred as deltas.

The first issue is an issue with many cloud synchronization tools, with "LAN Sync" being a largely proprietary feature [1](https://en.wikipedia.org/wiki/Comparison_of_file_synchronization_software). It could be possible to sync between local nodes using rclone, but it's hardly made for this purpose.

The second issue is also characteristic of traditional cloud file storage; see [this rclone FAQ entry](https://rclone.org/faq/#why-doesn-t-rclone-support-partial-transfers-binary-diffs-like-rsync).

My initial plan was to migrate from MEGASync to rclone, via its newfound [bisync support](https://github.com/rclone/rclone/issues/5674). Given these shortcomings, though, there seems to be a better way.

## Local data synchronization

The two best-regarded local data synchronization programs are [Syncthing](https://en.wikipedia.org/wiki/Syncthing) and [Resilio Sync](https://en.wikipedia.org/wiki/Comparison_of_file_synchronization_software). Syncthing is FOSS so we go with that.

First, on both of my systems I [installed](https://wiki.archlinux.org/title/Install) the [Syncthing package](https://archlinux.org/packages/community/x86_64/syncthing/) on my systems and [enabled](https://wiki.archlinux.org/title/Enable) the systemd user unit.

## Remote backups

It turns out that, in order to solve the problem of getting your data in the cloud, you must choose what kind of cloud storage you want:
- [File hosting services](https://en.wikipedia.org/wiki/Comparison_of_file_hosting_services) have ample accomodations for egress (including public file sharing), and are more likely to come with fleshed out web interfaces.
- [Online backup services](https://en.wikipedia.org/wiki/Comparison_of_online_backup_services) tend to have much cheaper ingress, at the cost of costly egress and/or lackluster public file sharing.

For our specialized use case, it seems that we actually don't want a traditional cloud provider like Google Drive, MEGA, or Dropbox.

To narrow it down even further, we can split online backup services into a couple of categories:
- Those which, while themselves are not optimized for public file sharing, can accomodate it. Example: Backblaze B2, which can be combined with a CDN for file publication.
- Those which do not store the files as is, i.e. *natively* use backup formats. The main (and perhaps only) example of this would be borg providers.

Note that using borg with a provider which does not natively support it (such as Backblaze) is generally possible if you put some glue in the middle, but tends to be a bad experience [1](https://github.com/borgbackup/borg/issues/1872#issuecomment-262605096) [2](https://github.com/borgbackup/borg/issues/5022#issuecomment-597926586).

Although the more general file backup services are perhaps more well established, borg hosts might be able to gain an edge by the more restricted (and optimized) functionality.

We will compare Backblaze B2—one of the cheapest offerings for file storage, especially at scale—to

Let's run the calculations for a humble 100GB.

Backblaze B2:

https://torsion.org/borgmatic/

actually nvm

https://www.reddit.com/r/BorgBackup/comments/v3bwfg/why_should_i_switch_from_restic_to_borg/
> Requires proprietary servers which charge way above the industry standard rates for storage. The best Borg hosting price costs between 3x to 30x as much as Backblaze B2 per gigabyte, depending how much data you need to store. The Borg hosts all force you to pay for at least 100 GB even if you don't use it, which means that it can easily become around 30x more expensive than Backblaze B2 if you don't store much data.
