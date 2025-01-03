{
    config,
    pkgs,
    inputs,
    system,
    gVar,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./../modules/base
        ./../modules/desktop
        ./../modules/users
        # ./../modules/server
    ];

    virtualisation.libvirtd.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        wget
        curl
        virt-manager
        qemu
        qemu_kvm
        compose2nix
        nixd
    ];

    users.users.${gVar.defaultUser} = {
        extraGroups = [
            "wheel"
            "networkmanager"
            "libvirtd"
            "docker"
            "podman"
            "nextcloud"
        ];
        packages = with pkgs; [
            brave
            discord
            spotify
            gnome-keyring
            filezilla
            foliate
            vhs
            charm-freeze
            glow
            # custom
            #jot
        ];
    };

    # Personal Modules
    battery.enable = true;

    tailscaleAutoConnect = {
        enable = true;
        authkeyFile = config.sops.secrets.tailscale_key.path;
        loginServer = "https://login.tailscale.com";
    };

    gnome.enable = true;

    # Believe it or not, if you change this? Straight to jail.
    system.stateVersion = "24.11";
}
