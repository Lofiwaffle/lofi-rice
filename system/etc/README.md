# System configurations - review before applying!

These are system-level configs that require root/sudo to modify.
Review carefully before overwriting system files!

## pacman.conf changes:

[options]
Color
ILoveCandy
VerbosePkgLists
HoldPkg = pacman glibc
Architecture = auto
CheckSpace
ParallelDownloads = 5
DownloadUser = alpm
SigLevel = Required DatabaseOptional
LocalFileSigLevel = Optional
[core]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
[warpdotdev]
Server = https://releases.warp.dev/linux/pacman/$repo/$arch
