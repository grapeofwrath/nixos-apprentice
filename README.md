# dotfiles

*Keep It Simple Stupid*

### NixOS

Each system added to the flake has a corresponding directory in [nixos/](./nixos/) that contains the main configuration file as well as the hardware configuration.
The directory is titled the hostname of its system.
The hostname and primary username are passed to the configuration through the **hostName** and **gVar.defaultUser** in **specialArgs**.

NixOS modules are located in [nixos/modules/](./nixos/modules/).
They are sorted between base, desktop, server, and users.
Options are assigned to these directories if they are meant to be used across multiple configurations.
Modules are separated into files if they are opt-in or they have different custom options to choose from for each configuration.

### Home Manager

Home Manager is installed as a NixOS module (see [users/default.nix](./nixos/modules/users/default.nix)) and as standalone configurations in the flake.
Each configuration added to the flake has a file located in [home-manager/](./home-manager/).
The filename is the user followed by the hostname (ie. user-host.nix).
Inside the flake, the hostname and username are passed through **extraSpecialArgs** to the configurations.

Home manager modules are located in [home-manager/modules/](./home-manager/modules/).
They are sorted between base, desktop, and server.
Similar to the NixOS modules, options are assigned to these directories if they are meant to be used across multiple configurations.
Modules are also separated into files if they are opt-in or they have different custom options to choose from for each configuration.

### [Users](./nixos/modules/users/default.nix)

Technically, I can add more users to a system from the users module using **users.additionalUsers**.
This currently works as a list of usernames.
Each user in the list is then assigned a configuration that looks like so:

```nix
username = {
    name = username;
    isNormalUser = true;
    home = "/home/${username}";
    group = "users";
    extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
    ];
    openssh.authorizedKeys.keys = map (builtins.readFile) keyScan;
};

home-manager.users = {
    username = import ./../../../home-manager/${username}-${hostName}.nix;
};
```

This works well enough, but it's not very flexible.
I'm going to expand on it at some point with submodules and such; I just don't have any multi-user systems right now.

### [gLib](./lib/default.nix)

Imported in the flake as **gLib**, this contains two helper functions: **scanPaths** and **scanFIles**.

**scanPaths** is used to import all nix files *(excluding default.nix)* in a directory.

```nix
{ inputs, gLib, ...} {
    imports = gLib.scanPaths ./.;

    # you can also append additional imports, ie modules from other flakes
    imports = (gLib.scanPaths ./.) ++ [inputs.bigChungus.nixosModules.carrots];
}
```

**scanFiles** is used to generate a list of all files in a directory.
The only spot I use this currently is as a helper for generating **openssh.authorizedKeys**.

```nix
# nixos/modules/users/default.nix

{ gLib,... }: let
    keyScan = gLib.scanFiles ./keys;
in {
    ...
    openssh.authorizedKeys.keys = map (builtins.readFile) keyScan;
    ...
```

### [gVar](./var/default.nix)

This simply contains the **defaultUser** variable as well as the color palette and any other variables I might want to add in the future.

## Adding a new system

Use nix-shell with git in order to clone this repo.
Then enter the directory and use [shell.nix](./shell.nix) provided for the rest of the process.

```sh
nix-shell -p git --command "git clone https://github.com/grapeofwrath/dotfiles.git"
cd dotfiles
nix-shell
```

Ensure that **~/.config/sops/age/keys.txt** exists on target system and that it matches that file on existing hosts.

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

Create an access key specific to the system using its public ssh key.
Add it to the hosts section in [.sops.yaml](./.sops.yaml).
Update [secrets.yaml](./secrets.yaml) with sops.

```sh
cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
vim .sops.yaml
sops updatekeys secrets.yaml
```

Generate an ssh key for the user and add it to [secrets.yaml](./secrets.yaml), removing the file afterwards.
Move the public key to [nixos/modules/users/keys/](./nixos/modules/users/keys/) and don't forget to upload it to github.
Add any NixOS/Home-Manager files to [nixos/](./nixos/) and [home-manager/](./home-manager/) and update the flake accordingly.
Rebuild the system with the new configuration.

```sh
ssh-keygen -t ed25519 -f id_<user>-<host> -C <user>@<host>
cat id_<user>-<host>
sops secrets.yaml
rm id_<user>-<host>
mv id_<user>-<host>.pub nixos/modules/users/keys/
```
