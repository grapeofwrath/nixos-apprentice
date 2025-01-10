# NixOS Apprentice

_Keep It Simple Stupid_

### What do?

This sets up a system with Plasma and Steam ready to go, ensuring that you have
all you need to pown all the noobs.

### Who for?

I built this primarily for any friends who might want to try linux.

### Why though?

Why not Endeavor or even Bazzite? You might ask. Well, I enjoy NixOS for one.
While it's quite different from traditional linux, I think there is a bright
future for it. The ability to roll-back after updates is pretty slick, and any
changes you might need to make are all documented within your configuration. If
you just want a simple system that works, Nix is a pretty great solution. I've
used Arch for many years, and Arch is great. Nix is spectacular.

## Documentation (WIP)

## Adding a new system (WIP)

Use nix-shell with git in order to clone this repo. Then enter the directory and
use [shell.nix](./shell.nix) provided for the rest of the process.

```sh
nix-shell -p git --command "git clone https://github.com/grapeofwrath/nixos-apprentice.git"
cd nixos-apprentice
nix-shell
```
