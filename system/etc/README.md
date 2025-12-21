# System configurations - review before applying!

These are system-level configs that require root/sudo to modify.
Review carefully before overwriting system files!

## pacman.conf changes:

[options]
HoldPkg     = pacman glibc
Architecture = auto
Color
ILoveCandy
CheckSpace
ParallelDownloads = 5
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
[core]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
[warpdotdev]
Server = https://releases.warp.dev/linux/pacman/$repo/$arch
